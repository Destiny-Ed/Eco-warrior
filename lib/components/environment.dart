import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../levels/level_data.dart';

/// Clean, structured decorative environments per level theme.
class EnvironmentLayer extends PositionComponent {
  final LevelTheme theme;

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
    // Clean horizontal path
    add(RectangleComponent(
      size: Vector2(size.x, 48),
      position: Vector2(0, size.y * 0.58),
      paint: Paint()..color = const Color(0xFFD7CCC8),
    ));
    // Path edge lines
    add(RectangleComponent(
      size: Vector2(size.x, 3),
      position: Vector2(0, size.y * 0.58),
      paint: Paint()..color = const Color(0xFFA1887F),
    ));

    // Structured row of houses
    final houseWidth = 58.0;
    final startX = 24.0;
    final gap = (size.x - 48 - houseWidth * 4) / 3;
    for (int i = 0; i < 4; i++) {
      final x = startX + i * (houseWidth + gap);
      add(_House(position: Vector2(x, size.y * 0.30)));
    }

    // Neat background trees
    for (int i = 0; i < 4; i++) {
      add(_DecorTree(
        position: Vector2(40 + i * (size.x / 4), size.y * 0.42),
      ));
    }

    // People walking on the path
    add(_MovingNpc(emoji: '🚶', y: size.y * 0.60, speed: 22, fromLeft: true));
    add(_MovingNpc(emoji: '👫', y: size.y * 0.62, speed: 18, fromLeft: false));
  }

  void _buildCity() {
    // Street
    add(RectangleComponent(
      size: Vector2(size.x, 60),
      position: Vector2(0, size.y * 0.55),
      paint: Paint()..color = const Color(0xFF546E7A),
    ));
    // Center line
    for (int i = 0; i < 10; i++) {
      add(RectangleComponent(
        size: Vector2(28, 4),
        position: Vector2(i * 55.0 + 10, size.y * 0.55 + 28),
        paint: Paint()..color = Colors.white.withOpacity(0.85),
      ));
    }

    // Clean row of buildings
    final heights = [95.0, 120.0, 85.0, 110.0, 100.0];
    for (int i = 0; i < 5; i++) {
      final h = heights[i];
      add(RectangleComponent(
        size: Vector2(48, h),
        position: Vector2(18 + i * 72.0, size.y * 0.55 - h),
        paint: Paint()..color = i.isEven ? const Color(0xFF37474F) : const Color(0xFF455A64),
      ));
      // Windows
      for (int w = 0; w < 3; w++) {
        add(RectangleComponent(
          size: Vector2(8, 10),
          position: Vector2(28 + i * 72.0, size.y * 0.55 - h + 20 + w * 22),
          paint: Paint()..color = const Color(0xFFFFF59D).withOpacity(0.7),
        ));
      }
    }

    add(_MovingNpc(emoji: '🚗', y: size.y * 0.58, speed: 38, fromLeft: true));
    add(_MovingNpc(emoji: '🚶‍♂️', y: size.y * 0.61, speed: 20, fromLeft: false));
  }

  void _buildBeach() {
    // Water
    add(RectangleComponent(
      size: Vector2(size.x, size.y * 0.22),
      position: Vector2(0, size.y * 0.32),
      paint: Paint()..color = const Color(0xFF29B6F6).withOpacity(0.55),
    ));
    // Sand
    add(RectangleComponent(
      size: Vector2(size.x, size.y * 0.38),
      position: Vector2(0, size.y * 0.52),
      paint: Paint()..color = const Color(0xFFFFE082).withOpacity(0.75),
    ));

    // Evenly spaced palms
    for (int i = 0; i < 3; i++) {
      add(_DecorTree(
        position: Vector2(50 + i * 130.0, size.y * 0.50),
        isPalm: true,
      ));
    }

    add(_MovingNpc(emoji: '🐋', y: size.y * 0.40, speed: 16, fromLeft: true));
    add(_MovingNpc(emoji: '🦈', y: size.y * 0.38, speed: 14, fromLeft: false));
  }

  void _buildForest() {
    // Structured tree rows
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 5; col++) {
        add(_DecorTree(
          position: Vector2(
            30 + col * (size.x / 5),
            size.y * 0.28 + row * 45,
          ),
        ));
      }
    }
    add(_MovingNpc(emoji: '🐺', y: size.y * 0.58, speed: 20, fromLeft: true));
    add(_MovingNpc(emoji: '🦌', y: size.y * 0.60, speed: 17, fromLeft: false));
  }

  void _buildFinal() {
    final heights = [80.0, 105.0, 90.0, 115.0];
    for (int i = 0; i < 4; i++) {
      final h = heights[i];
      add(RectangleComponent(
        size: Vector2(52, h),
        position: Vector2(30 + i * 90.0, size.y * 0.52 - h),
        paint: Paint()..color = const Color(0xFF37474F),
      ));
    }
    add(RectangleComponent(
      size: Vector2(size.x, 36),
      position: Vector2(0, size.y * 0.54),
      paint: Paint()..color = const Color(0xFF546E7A),
    ));
    add(_MovingNpc(emoji: '🚗', y: size.y * 0.56, speed: 32, fromLeft: true));
  }
}

class _House extends PositionComponent {
  _House({required Vector2 position})
      : super(position: position, size: Vector2(58, 52));

  @override
  Future<void> onLoad() async {
    // Body
    add(RectangleComponent(
      size: Vector2(52, 34),
      position: Vector2(3, 16),
      paint: Paint()..color = const Color(0xFFFFE0B2),
    ));
    // Roof
    add(RectangleComponent(
      size: Vector2(58, 16),
      position: Vector2(0, 2),
      paint: Paint()..color = const Color(0xFFE57373),
    ));
    // Door
    add(RectangleComponent(
      size: Vector2(12, 16),
      position: Vector2(23, 34),
      paint: Paint()..color = const Color(0xFF6D4C41),
    ));
    // Window
    add(RectangleComponent(
      size: Vector2(10, 10),
      position: Vector2(10, 24),
      paint: Paint()..color = const Color(0xFF81D4FA),
    ));
  }
}

class _DecorTree extends PositionComponent {
  final bool isPalm;
  _DecorTree({required Vector2 position, this.isPalm = false})
      : super(position: position, size: Vector2(34, 48), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(
      size: Vector2(7, 18),
      position: Vector2(13.5, 30),
      paint: Paint()..color = const Color(0xFF5D4037),
    ));
    add(CircleComponent(
      radius: isPalm ? 11 : 14,
      position: Vector2(17, 16),
      paint: Paint()..color = isPalm ? const Color(0xFF66BB6A) : const Color(0xFF2E7D32),
    ));
  }
}

class _MovingNpc extends PositionComponent {
  final String emoji;
  final double speed;
  final double y;
  final bool fromLeft;

  _MovingNpc({
    required this.emoji,
    required this.y,
    required this.speed,
    required this.fromLeft,
  }) : super(
          position: Vector2(fromLeft ? -40 : 420, y),
          size: Vector2(32, 32),
          priority: -5,
        );

  @override
  Future<void> onLoad() async {
    add(TextComponent(
      text: emoji,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 24)),
    ));
  }

  @override
  void update(double dt) {
    position.x += (fromLeft ? speed : -speed) * dt;
    if (fromLeft && position.x > 450) position.x = -40;
    if (!fromLeft && position.x < -50) position.x = 450;
  }
}
