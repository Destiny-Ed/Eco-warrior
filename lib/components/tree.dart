import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TreeComponent extends PositionComponent {
  TreeComponent({required Vector2 position})
      : super(
          position: position,
          size: Vector2(40, 50),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    // Trunk
    add(RectangleComponent(
      size: Vector2(10, 20),
      paint: Paint()..color = const Color(0xFF6D4C41),
      position: Vector2(15, 30),
    ));
    // Foliage
    add(CircleComponent(
      radius: 16,
      paint: Paint()..color = const Color(0xFF66BB6A),
      position: Vector2(20, 18),
    ));
    add(CircleComponent(
      radius: 12,
      paint: Paint()..color = const Color(0xFF43A047),
      position: Vector2(12, 22),
    ));
    add(CircleComponent(
      radius: 12,
      paint: Paint()..color = const Color(0xFF43A047),
      position: Vector2(28, 22),
    ));
  }
}
