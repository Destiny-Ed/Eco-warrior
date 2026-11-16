import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Trash extends PositionComponent with CollisionCallbacks {
  final Random _random = Random();
  late final Color color;

  Trash({required Vector2 position})
      : super(
          position: position,
          size: Vector2(28, 28),
          anchor: Anchor.center,
        ) {
    // Random fun colors for bottles/cans
    final colors = [
      const Color(0xFF42A5F5), // blue bottle
      const Color(0xFFEF5350), // red can
      const Color(0xFFFFCA28), // yellow
      const Color(0xFFAB47BC), // purple
      const Color(0xFF26C6DA), // cyan
    ];
    color = colors[_random.nextInt(colors.length)];
  }

  @override
  Future<void> onLoad() async {
    // Body
    add(RoundedRectangleComponent(
      size: size * 0.85,
      cornerRadius: const Radius.circular(6),
      paint: Paint()..color = color,
      anchor: Anchor.center,
      position: size / 2,
    ));
    // Shine
    add(CircleComponent(
      radius: 4,
      paint: Paint()..color = Colors.white.withOpacity(0.6),
      position: Vector2(8, 6),
    ));
    add(RectangleHitbox());
  }
}

class RoundedRectangleComponent extends PositionComponent {
  final Radius cornerRadius;
  final Paint paint;

  RoundedRectangleComponent({
    required Vector2 size,
    required this.cornerRadius,
    required this.paint,
    super.position,
    super.anchor,
  }) : super(size: size);

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      size.toRect(),
      cornerRadius,
    );
    canvas.drawRRect(rrect, paint);
  }
}
