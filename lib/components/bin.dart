import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bin extends PositionComponent {
  Bin({required Vector2 position})
      : super(
          position: position,
          size: Vector2(50, 60),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    // Bin body
    add(RectangleComponent(
      size: Vector2(40, 45),
      paint: Paint()..color = const Color(0xFF43A047),
      position: Vector2(5, 10),
    ));
    // Lid
    add(RectangleComponent(
      size: Vector2(46, 10),
      paint: Paint()..color = const Color(0xFF2E7D32),
      position: Vector2(2, 5),
    ));
    // Recycle symbol approximation
    add(TextComponent(
      text: '♻️',
      position: Vector2(12, 20),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 22),
      ),
    ));
  }
}
