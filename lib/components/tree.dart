import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TreeComponent extends PositionComponent {
  TreeComponent({required Vector2 position})
      : super(
          position: position,
          size: Vector2(48, 60),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    // Trunk
    add(RectangleComponent(
      size: Vector2(12, 24),
      paint: Paint()..color = const Color(0xFF6D4C41),
      position: Vector2(18, 36),
    ));

    // Foliage layers for a friendly look
    add(CircleComponent(
      radius: 18,
      paint: Paint()..color = const Color(0xFF66BB6A),
      position: Vector2(24, 22),
    ));
    add(CircleComponent(
      radius: 14,
      paint: Paint()..color = const Color(0xFF43A047),
      position: Vector2(14, 26),
    ));
    add(CircleComponent(
      radius: 14,
      paint: Paint()..color = const Color(0xFF43A047),
      position: Vector2(34, 26),
    ));

    // Small sparkle
    add(TextComponent(
      text: '✨',
      position: Vector2(8, 8),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 12)),
    ));
  }
}
