import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../levels/level_data.dart';

/// Decorative background elements that make each level feel like a real place.
class EnvironmentLayer extends PositionComponent {
  final LevelTheme theme;
  final Random _random = Random();

  EnvironmentLayer({required this.theme, required Vector2 size})
      : super(size: size, priority: -10);

  @override
  Future<void> onLoad() async {
    switch (theme) {
      case LevelTheme.neighborhood:
        _buildNeighborhood();
        break;
      case LevelTheme.city:
        _buildCity();
        break;
      case LevelTheme.beach:
        _buildBeach();
        break;
      case LevelTheme.forest:
        _buildForest();
        break;
      case LevelTheme.finalCall:
        _buildFinal();
        break;
    }
  }

  void _buildNeighborhood() {
    // Sky gradient feel already from backgroundColor
    // Road / path
    add(RectangleComponent(
      size: Vector2(size.x, 40),
      position: Vector2(0, size.y * 0.55),
      paint: Paint()..color = const Color(0xFFBCAAA4).withOpacity(0.6),
    ));

    // Simple houses in the background
    for (int i = 0; i < 4; i++) {
      final x = 30.0 + i * (size.x / 4);
      add(_House(position: Vector2(x, size.y * 0.28 + _random.nextDouble() * 20)));
    }

    // A few static trees
    for (int i = 0; i < 5; i++) {
      add(_DecorTree(
        position: Vector2(
          20 + _random.nextDouble() * (size.x - 40),
          size.y * 0.35 + _random.nextDouble() * 40,
        ),
      ));
    }

    // Moving people (simple)
    add(_MovingNpc(emoji: '🚶', startX: 20, y: size.y * 0.58, speed: 25));
    add(_MovingNpc(emoji: '👫', startX: size.x - 40, y: size.y * 0.60, speed: -20));
  }

  void _buildCity() {
    // Road
    add(RectangleComponent(
      size: Vector2(size.x, 55),
      position: Vector2(0, size.y * 0.52),
      paint: Paint()..color = const Color(0xFF546E7A),
    ));
    // Road lines
    for (int i = 0; i < 8; i++) {
      add(RectangleComponent(
        size: Vector2(30, 4),
        position: Vector2(i * 60.0, size.y * 0.52 + 25),
        paint: Paint()..color = Colors.white.withOpacity(0.7),
      ));
    }

    // Tall buildings
    for (int i = 0; i < 5; i++) {
      final h = 80.0 + _random.nextDouble() * 60;
      add(RectangleComponent(
        size: Vector2(45, h),
        position: Vector2(20 + i * 70.0, size.y * 0.52 - h),
        paint: Paint()..color = Color.lerp(const Color(0xFF37474F), const Color(0xFF78909C), _random.nextDouble())!,
      ));
    }

    add(_MovingNpc(emoji: '🚗', startX: -30, y: size.y * 0.55, speed: 40));
    add(_MovingNpc(emoji: '🚶‍♂️', startX: size.x + 20, y: size.y * 0.58, speed: -30));
  }

  void _buildBeach() {
    // Sand
    add(RectangleComponent(
      size: Vector2(size.x, size.y * 0.35),
      position: Vector2(0, size.y * 0.55),
      paint: Paint()..color = const Color(0xFFFFE082).withOpacity(0.7),
    ));
    // Water
    add(RectangleComponent(
      size: Vector2(size.x, size.y * 0.2),
      position: Vector2(0, size.y * 0.35),
      paint: Paint()..color = const Color(0xFF4FC3F7).withOpacity(0.5),
    ));

    // Simple palm-like trees
    for (int i = 0; i < 3; i++) {
      add(_DecorTree(
        position: Vector2(40 + i * 120.0, size.y * 0.48),
        isPalm: true,
      ));
    }

    add(_MovingNpc(emoji: '🐋', startX: 10, y: size.y * 0.42, speed: 18));
    add(_MovingNpc(emoji: '🦈', startX: size.x - 30, y: size.y * 0.40, speed: -15));
  }

  void _buildForest() {
    for (int i = 0; i < 8; i++) {
      add(_DecorTree(
        position: Vector2(
          15 + _random.nextDouble() * (size.x - 30),
          size.y * 0.25 + _random.nextDouble() * 80,
        ),
      ));
    }
    add(_MovingNpc(emoji: '🐺', startX: 20, y: size.y * 0.55, speed: 22));
    add(_MovingNpc(emoji: '🦌', startX: size.x - 40, y: size.y * 0.58, speed: -18));
  }

  void _buildFinal() {
    // Mix of city + pollution feel
    for (int i = 0; i < 4; i++) {
      final h = 70.0 + _random.nextDouble() * 50;
      add(RectangleComponent(
        size: Vector2(40, h),
        position: Vector2(25 + i * 85.0, size.y * 0.5 - h),
        paint: Paint()..color = const Color(0xFF455A64),
      ));
    }
    add(RectangleComponent(
      size: Vector2(size.x, 30),
      position: Vector2(0, size.y * 0.52),
      paint: Paint()..color = const Color(0xFF546E7A).withOpacity(0.8),
    ));
    add(_MovingNpc(emoji: '🚗', startX: -20, y: size.y * 0.54, speed: 35));
  }
}

class _House extends PositionComponent {
  _House({required Vector2 position}) : super(position: position, size: Vector2(55, 50));

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(
      size: Vector2(50, 35),
      position: Vector2(2.5, 15),
      paint: Paint()..color = const Color(0xFFFFCC80),
    ));
    // Roof
    add(RectangleComponent(
      size: Vector2(58, 18),
      position: Vector2(-1.5, 0),
      paint: Paint()..color = const Color(0xFFE57373),
    ));
  }
}

class _DecorTree extends PositionComponent {
  final bool isPalm;
  _DecorTree({required Vector2 position, this.isPalm = false})
      : super(position: position, size: Vector2(36, 50), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(
      size: Vector2(8, 20),
      position: Vector2(14, 30),
      paint: Paint()..color = const Color(0xFF6D4C41),
    ));
    add(CircleComponent(
      radius: isPalm ? 12 : 16,
      position: Vector2(18, 18),
      paint: Paint()..color = isPalm ? const Color(0xFF66BB6A) : const Color(0xFF43A047),
    ));
  }
}

class _MovingNpc extends PositionComponent {
  final String emoji;
  final double speed;
  final double startX;
  final double y;

  _MovingNpc({
    required this.emoji,
    required this.startX,
    required this.y,
    required this.speed,
  }) : super(position: Vector2(startX, y), size: Vector2(30, 30), priority: -5);

  @override
  Future<void> onLoad() async {
    add(TextComponent(
      text: emoji,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 22)),
    ));
  }

  @override
  void update(double dt) {
    position.x += speed * dt;
    if (speed > 0 && position.x > 400) position.x = -30;
    if (speed < 0 && position.x < -40) position.x = 420;
  }
}
