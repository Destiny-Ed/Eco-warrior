import 'dart:async';
import 'dart:async' as timer;
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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
  late TextComponent tipText;

  int trashCollected = 0;
  int treesPlanted = 0;
  int health = 3;
  bool isPaused = false;
  bool isComplete = false;

  Vector2 joystickDirection = Vector2.zero();
  final Random _random = Random();

  timer.Timer? _spawnTimer;
  timer.Timer? _hazardTimer;

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
    // Soft decorative ground
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = level.backgroundColor.withOpacity(0.9),
    ));

    // Player
    player = Player(position: Vector2(size.x / 2, size.y * 0.7));
    add(player);

    // Recycling Bin
    add(Bin(position: Vector2(size.x - 60, size.y - 80)));

    // Initial trash
    for (int i = 0; i < level.initialTrash; i++) {
      _spawnTrash();
    }

    // HUD
    hudText = TextComponent(
      text: _hudString(),
      position: Vector2(16, 16),
      priority: 100,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.6), blurRadius: 4, offset: const Offset(1, 1)),
          ],
        ),
      ),
    );
    add(hudText);

    // Educational tip at bottom
    tipText = TextComponent(
      text: '💡 ${level.tip}',
      position: Vector2(16, size.y - 40),
      priority: 100,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 12,
          fontStyle: FontStyle.italic,
          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 3)],
        ),
      ),
    );
    add(tipText);

    // Spawn timers
    _spawnTimer = timer.Timer.periodic(level.spawnInterval, (_) {
      if (!isPaused && !isComplete) _spawnTrash();
    });

    if (level.hasHazards) {
      _hazardTimer = timer.Timer.periodic(const Duration(seconds: 5), (_) {
        if (!isPaused && !isComplete) _spawnHazard();
      });
    }
  }

  String _hudString() {
    final treePart = level.treesToPlant > 0 ? '  🌳 $treesPlanted/${level.treesToPlant}' : '';
    return '🗑️ $trashCollected/${level.trashTarget}$treePart  ❤️ $health';
  }

  void _spawnTrash() {
    final pos = Vector2(
      40 + _random.nextDouble() * (size.x - 80),
      80 + _random.nextDouble() * (size.y - 200),
    );
    add(Trash(position: pos));
  }

  void _spawnHazard() {
    if (level.hazardType == null) return;
    final fromLeft = _random.nextBool();
    final pos = Vector2(
      fromLeft ? -30 : size.x + 30,
      100 + _random.nextDouble() * (size.y - 250),
    );
    add(Hazard(
      position: pos,
      type: level.hazardType!,
      speed: level.hazardSpeed,
      direction: fromLeft ? Vector2(1, 0) : Vector2(-1, 0),
    ));
  }

  void collectTrash() {
    trashCollected++;
    hudText.text = _hudString();
    _checkWin();
  }

  void plantTree() {
    if (treesPlanted >= level.treesToPlant) return;
    treesPlanted++;
    final pos = Vector2(
      50 + _random.nextDouble() * (size.x - 100),
      size.y - 120 - _random.nextDouble() * 40,
    );
    add(TreeComponent(position: pos));
    hudText.text = _hudString();
    _checkWin();
  }

  void takeDamage() {
    health--;
    hudText.text = _hudString();
    if (health <= 0) {
      isComplete = true;
      onGameOver();
    }
  }

  void _checkWin() {
    if (trashCollected >= level.trashTarget &&
        treesPlanted >= level.treesToPlant) {
      isComplete = true;
      onLevelComplete();
    }
  }

  void pickNearbyTrash() {
    const radius = 55.0;
    for (final trash in children.whereType<Trash>().toList()) {
      if (player.position.distanceTo(trash.position) < radius) {
        trash.removeFromParent();
        collectTrash();
      }
    }
  }

  void reset() {
    trashCollected = 0;
    treesPlanted = 0;
    health = 3;
    isPaused = false;
    isComplete = false;
    joystickDirection = Vector2.zero();

    children.whereType<Trash>().forEach((c) => c.removeFromParent());
    children.whereType<Hazard>().forEach((c) => c.removeFromParent());
    children.whereType<TreeComponent>().forEach((c) => c.removeFromParent());

    for (int i = 0; i < level.initialTrash; i++) {
      _spawnTrash();
    }
    player.position = Vector2(size.x / 2, size.y * 0.7);
    hudText.text = _hudString();
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
