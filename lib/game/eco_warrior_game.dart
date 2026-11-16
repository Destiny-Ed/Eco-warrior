import 'dart:async' as timer;
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../levels/level_data.dart';
import '../components/player.dart';
import '../components/trash.dart';
import '../components/hazard.dart';
import '../components/bin.dart';
import '../components/tree.dart';
import '../components/environment.dart';
import '../components/obstacle.dart';

class EcoWarriorGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  final LevelConfig level;
  final double topSafePadding;
  final VoidCallback onPause;
  final VoidCallback onLevelComplete;
  final VoidCallback onGameOver;
  final VoidCallback onTimeUp;

  late Player player;
  late TextComponent hudText;
  late TextComponent instructionText;
  late TextComponent timerText;

  int trashCollected = 0;
  int treesPlanted = 0;
  int health = 3;
  int score = 0;
  int totalTrashSpawned = 0;
  bool isPaused = false;
  bool isComplete = false;

  Vector2 joystickDirection = Vector2.zero();
  final Random _random = Random();

  timer.Timer? _spawnTimer;
  timer.Timer? _hazardTimer;
  timer.Timer? _countdownTimer;

  int remainingSeconds = 0;
  final List<Bin> bins = [];

  // Hard cap: never spawn more trash than needed for the goal + small buffer
  int get maxTrashAllowed => level.trashTarget + 3;

  EcoWarriorGame({
    required this.level,
    required this.topSafePadding,
    required this.onPause,
    required this.onLevelComplete,
    required this.onGameOver,
    required this.onTimeUp,
  });

  @override
  Color backgroundColor() => level.backgroundColor;

  @override
  Future<void> onLoad() async {
    remainingSeconds = level.timeLimitSeconds;

    add(EnvironmentLayer(theme: level.theme, size: size));

    // Light overlay for readability
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = level.backgroundColor.withOpacity(0.18),
      priority: -5,
    ));

    player = Player(position: Vector2(size.x / 2, size.y * 0.62));
    add(player);

    // Bins at very bottom
    final binTypes = TrashType.values;
    final spacing = size.x / 5;
    for (int i = 0; i < binTypes.length; i++) {
      final bin = Bin(
        position: Vector2(spacing * (i + 1), size.y - 58),
        acceptsType: binTypes[i],
      );
      bins.add(bin);
      add(bin);
    }

    _spawnObstacles();

    // Initial trash – limited to what is needed
    final initial = level.initialTrash.clamp(0, maxTrashAllowed);
    for (int i = 0; i < initial; i++) {
      _spawnTrash();
    }

    // ===== Clean HUD layout =====
    final hudTop = topSafePadding + 10;

    // Left: progress
    hudText = TextComponent(
      text: _hudString(),
      position: Vector2(14, hudTop),
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          shadows: [Shadow(color: Colors.black54, blurRadius: 3, offset: Offset(1, 1))],
        ),
      ),
    );
    add(hudText);

    // Right: timer (with space so pause button doesn't cover it)
    timerText = TextComponent(
      text: _timerString(),
      position: Vector2(size.x - 56, hudTop),
      anchor: Anchor.topRight,
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFF176),
          fontSize: 17,
          fontWeight: FontWeight.w800,
          shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
        ),
      ),
    );
    add(timerText);

    // Center instruction
    instructionText = TextComponent(
      text: 'Move • Pick trash • Deliver to matching bin',
      position: Vector2(size.x / 2, hudTop + 28),
      anchor: Anchor.topCenter,
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
        ),
      ),
    );
    add(instructionText);

    // Smarter spawning – only if under cap and current count is low
    _spawnTimer = timer.Timer.periodic(level.spawnInterval, (_) {
      if (isPaused || isComplete) return;
      final current = children.whereType<Trash>().length;
      if (current < 5 && totalTrashSpawned < maxTrashAllowed) {
        _spawnTrash();
      }
    });

    if (level.hasHazards) {
      _hazardTimer = timer.Timer.periodic(const Duration(seconds: 7), (_) {
        if (!isPaused && !isComplete) _spawnHazard();
      });
    }

    if (level.timeLimitSeconds > 0) {
      _countdownTimer = timer.Timer.periodic(const Duration(seconds: 1), (_) {
        if (isPaused || isComplete) return;
        remainingSeconds--;
        timerText.text = _timerString();
        if (remainingSeconds <= 0) {
          isComplete = true;
          onTimeUp();
        }
      });
    }
  }

  String _hudString() {
    final treePart = level.treesToPlant > 0 ? '  🌳$treesPlanted/${level.treesToPlant}' : '';
    return '🗑️$trashCollected/${level.trashTarget}$treePart  ❤$health  $score';
  }

  String _timerString() {
    if (level.timeLimitSeconds <= 0) return '';
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _updateInstruction() {
    if (player.isCarrying) {
      final t = player.carriedTrash!;
      instructionText.text = 'Deliver ${t.label} to the ${t.label} bin';
      instructionText.textRenderer = TextPaint(
        style: TextStyle(
          color: t.color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          shadows: const [Shadow(color: Colors.black54, blurRadius: 3)],
        ),
      );
    } else {
      instructionText.text = 'Move • Pick trash • Deliver to matching bin';
      instructionText.textRenderer = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
        ),
      );
    }
  }

  void _spawnTrash() {
    if (totalTrashSpawned >= maxTrashAllowed) return;
    totalTrashSpawned++;
    final pos = Vector2(
      50 + _random.nextDouble() * (size.x - 100),
      110 + _random.nextDouble() * (size.y - 320),
    );
    add(Trash(position: pos));
  }

  void _spawnHazard() {
    if (level.hazardType == null) return;
    final fromLeft = _random.nextBool();
    final pos = Vector2(
      fromLeft ? -30 : size.x + 30,
      130 + _random.nextDouble() * (size.y - 320),
    );
    add(Hazard(
      position: pos,
      type: level.hazardType!,
      speed: level.hazardSpeed,
      direction: fromLeft ? Vector2(1, 0) : Vector2(-1, 0),
    ));
  }

  void _spawnObstacles() {
    // 2–3 well-spaced obstacles
    final positions = [
      Vector2(size.x * 0.25, size.y * 0.38),
      Vector2(size.x * 0.75, size.y * 0.42),
      Vector2(size.x * 0.50, size.y * 0.33),
    ];
    for (final pos in positions.take(level.id >= 3 ? 3 : 2)) {
      add(Obstacle(position: pos));
    }
  }

  void tryPickTrash() {
    if (player.isCarrying) {
      _tryDeliver();
      return;
    }

    Trash? nearest;
    double nearestDist = 68;

    for (final trash in children.whereType<Trash>()) {
      final dist = player.position.distanceTo(trash.position);
      if (dist < nearestDist) {
        nearestDist = dist;
        nearest = trash;
      }
    }

    if (nearest != null) {
      player.pickUp(nearest);
      HapticFeedback.mediumImpact();
      _updateInstruction();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  void _tryDeliver() {
    if (!player.isCarrying) return;

    final carried = player.carriedTrash!;
    Bin? nearestBin;
    double nearestDist = 85;

    for (final bin in bins) {
      final dist = player.position.distanceTo(bin.position);
      if (dist < nearestDist) {
        nearestDist = dist;
        nearestBin = bin;
      }
    }

    if (nearestBin != null) {
      if (nearestBin.acceptsType == carried.type) {
        trashCollected++;
        score += 15;
        player.dropTrash();
        HapticFeedback.heavyImpact();
        hudText.text = _hudString();
        _updateInstruction();
        _checkWin();
      } else {
        HapticFeedback.vibrate();
        instructionText.text = 'Wrong bin! Find the ${carried.label} one';
      }
    }
  }

  void plantTree() {
    if (treesPlanted >= level.treesToPlant) return;
    treesPlanted++;
    score += 20;

    // Plant exactly where the warrior is standing
    final plantPos = player.position + Vector2(0, 18);
    add(TreeComponent(position: plantPos));

    HapticFeedback.lightImpact();
    hudText.text = _hudString();
    _checkWin();
  }

  void hitObstacle() {
    score = (score - 8).clamp(0, 99999);
    hudText.text = _hudString();
  }

  void takeDamage() {
    health--;
    score = (score - 12).clamp(0, 99999);
    HapticFeedback.heavyImpact();
    hudText.text = _hudString();
    if (health <= 0) {
      isComplete = true;
      onGameOver();
    }
  }

  void _checkWin() {
    if (trashCollected >= level.trashTarget && treesPlanted >= level.treesToPlant) {
      isComplete = true;
      score += remainingSeconds * 2;
      HapticFeedback.heavyImpact();
      onLevelComplete();
    }
  }

  void reset() {
    trashCollected = 0;
    treesPlanted = 0;
    health = 3;
    score = 0;
    totalTrashSpawned = 0;
    remainingSeconds = level.timeLimitSeconds;
    isPaused = false;
    isComplete = false;
    joystickDirection = Vector2.zero();
    player.dropTrash();

    children.whereType<Trash>().forEach((c) => c.removeFromParent());
    children.whereType<Hazard>().forEach((c) => c.removeFromParent());
    children.whereType<TreeComponent>().forEach((c) => c.removeFromParent());
    children.whereType<Obstacle>().forEach((c) => c.removeFromParent());

    _spawnObstacles();
    final initial = level.initialTrash.clamp(0, maxTrashAllowed);
    for (int i = 0; i < initial; i++) {
      _spawnTrash();
    }

    player.position = Vector2(size.x / 2, size.y * 0.62);
    hudText.text = _hudString();
    timerText.text = _timerString();
    _updateInstruction();
  }

  @override
  void update(double dt) {
    if (isPaused || isComplete) return;
    super.update(dt);
    player.move(joystickDirection, dt);
  }

  @override
  void onRemove() {
    _spawnTimer?.cancel();
    _hazardTimer?.cancel();
    _countdownTimer?.cancel();
    super.onRemove();
  }
}
