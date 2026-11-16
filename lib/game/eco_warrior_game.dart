import 'dart:async';
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

class EcoWarriorGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  final LevelConfig level;
  final VoidCallback onPause;
  final VoidCallback onLevelComplete;
  final VoidCallback onGameOver;

  late Player player;
  late TextComponent hudText;
  late TextComponent instructionText;

  int trashCollected = 0;
  int treesPlanted = 0;
  int health = 3;
  bool isPaused = false;
  bool isComplete = false;

  Vector2 joystickDirection = Vector2.zero();
  final Random _random = Random();

  Timer? _spawnTimer;
  Timer? _hazardTimer;

  // Bins for recycling
  final List<Bin> bins = [];

  EcoWarriorGame({
    required this.level,
    required this.onPause,
    required this.onLevelComplete,
    required this.onGameOver,
  });

  @override
  Color backgroundColor() => level.backgroundColor;

  @override
  Future<void> onLoad() async {
    // Soft background
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = level.backgroundColor.withOpacity(0.92),
    ));

    // Player
    player = Player(position: Vector2(size.x / 2, size.y * 0.65));
    add(player);

    // Four clearly labeled recycling bins at the bottom
    final binTypes = TrashType.values;
    final spacing = size.x / 5;
    for (int i = 0; i < binTypes.length; i++) {
      final bin = Bin(
        position: Vector2(spacing * (i + 1), size.y - 70),
        acceptsType: binTypes[i],
      );
      bins.add(bin);
      add(bin);
    }

    // Initial trash
    for (int i = 0; i < level.initialTrash; i++) {
      _spawnTrash();
    }

    // HUD
    hudText = TextComponent(
      text: _hudString(),
      position: Vector2(14, 14),
      priority: 100,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 4, offset: const Offset(1, 1)),
          ],
        ),
      ),
    );
    add(hudText);

    // Dynamic instruction text (very important for clarity)
    instructionText = TextComponent(
      text: 'Move with joystick • Tap hand to pick trash',
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.topCenter,
      priority: 100,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 4),
          ],
        ),
      ),
    );
    add(instructionText);

    // Spawn timers
    _spawnTimer = Timer.periodic(level.spawnInterval, (_) {
      if (!isPaused && !isComplete) _spawnTrash();
    });

    if (level.hasHazards) {
      _hazardTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!isPaused && !isComplete) _spawnHazard();
      });
    }
  }

  String _hudString() {
    final treePart = level.treesToPlant > 0 ? '  🌳 $treesPlanted/${level.treesToPlant}' : '';
    return '🗑️ $trashCollected/${level.trashTarget}$treePart  ❤️ $health';
  }

  void _updateInstruction() {
    if (player.isCarrying) {
      final t = player.carriedTrash!;
      instructionText.text = 'Take the ${t.label} to the matching ${t.label} bin!';
      instructionText.textRenderer = TextPaint(
        style: TextStyle(
          color: t.color,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 4)],
        ),
      );
    } else {
      instructionText.text = 'Move with joystick • Tap HAND to pick trash near you';
      instructionText.textRenderer = TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 4)],
        ),
      );
    }
  }

  void _spawnTrash() {
    final pos = Vector2(
      40 + _random.nextDouble() * (size.x - 80),
      90 + _random.nextDouble() * (size.y - 280),
    );
    add(Trash(position: pos));
  }

  void _spawnHazard() {
    if (level.hazardType == null) return;
    final fromLeft = _random.nextBool();
    final pos = Vector2(
      fromLeft ? -30 : size.x + 30,
      100 + _random.nextDouble() * (size.y - 280),
    );
    add(Hazard(
      position: pos,
      type: level.hazardType!,
      speed: level.hazardSpeed,
      direction: fromLeft ? Vector2(1, 0) : Vector2(-1, 0),
    ));
  }

  void tryPickTrash() {
    if (player.isCarrying) {
      // Try to deliver to a bin
      _tryDeliver();
      return;
    }

    // Pick nearest trash in range
    Trash? nearest;
    double nearestDist = 70;

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
    double nearestDist = 90;

    for (final bin in bins) {
      final dist = player.position.distanceTo(bin.position);
      if (dist < nearestDist) {
        nearestDist = dist;
        nearestBin = bin;
      }
    }

    if (nearestBin != null) {
      if (nearestBin.acceptsType == carried.type) {
        // Correct bin!
        trashCollected++;
        player.dropTrash();
        HapticFeedback.heavyImpact();
        hudText.text = _hudString();
        _updateInstruction();
        _checkWin();
      } else {
        // Wrong bin - gentle feedback
        HapticFeedback.vibrate();
        // Keep the trash, just shake instruction
        instructionText.text = 'Wrong bin! Find the ${carried.label} bin';
      }
    }
  }

  void plantTree() {
    if (treesPlanted >= level.treesToPlant) return;
    treesPlanted++;
    final pos = Vector2(
      40 + _random.nextDouble() * (size.x - 80),
      size.y - 160 - _random.nextDouble() * 30,
    );
    add(TreeComponent(position: pos));
    HapticFeedback.lightImpact();
    hudText.text = _hudString();
    _checkWin();
  }

  void takeDamage() {
    health--;
    HapticFeedback.vibrate();
    hudText.text = _hudString();
    if (health <= 0) {
      isComplete = true;
      onGameOver();
    }
  }

  void _checkWin() {
    if (trashCollected >= level.trashTarget && treesPlanted >= level.treesToPlant) {
      isComplete = true;
      HapticFeedback.heavyImpact();
      onLevelComplete();
    }
  }

  void reset() {
    trashCollected = 0;
    treesPlanted = 0;
    health = 3;
    isPaused = false;
    isComplete = false;
    joystickDirection = Vector2.zero();
    player.dropTrash();

    children.whereType<Trash>().forEach((c) => c.removeFromParent());
    children.whereType<Hazard>().forEach((c) => c.removeFromParent());
    children.whereType<TreeComponent>().forEach((c) => c.removeFromParent());

    for (int i = 0; i < level.initialTrash; i++) {
      _spawnTrash();
    }
    player.position = Vector2(size.x / 2, size.y * 0.65);
    hudText.text = _hudString();
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
    super.onRemove();
  }
}
