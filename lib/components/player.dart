import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/eco_warrior_game.dart';

class Player extends PositionComponent with HasGameRef<EcoWarriorGame>, CollisionCallbacks {
  static const double speed = 180;

  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2(48, 48),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    // Cute eco-hero body (green circle + cape feel)
    add(CircleComponent(
      radius: 22,
      paint: Paint()..color = const Color(0xFF66BB6A),
      anchor: Anchor.center,
      position: size / 2,
    ));
    // Head / face
    add(CircleComponent(
      radius: 12,
      paint: Paint()..color = const Color(0xFFFFCC80),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 - 10),
    ));
    // Eyes
    add(CircleComponent(
      radius: 3,
      paint: Paint()..color = Colors.black,
      position: Vector2(size.x / 2 - 5, size.y / 2 - 12),
    ));
    add(CircleComponent(
      radius: 3,
      paint: Paint()..color = Colors.black,
      position: Vector2(size.x / 2 + 5, size.y / 2 - 12),
    ));
    // Smile
    add(RectangleComponent(
      size: Vector2(10, 3),
      paint: Paint()..color = Colors.black87,
      position: Vector2(size.x / 2 - 5, size.y / 2 - 4),
    ));
    // Eco cape / leaf
    add(CircleComponent(
      radius: 8,
      paint: Paint()..color = const Color(0xFF43A047),
      position: Vector2(size.x / 2 + 14, size.y / 2 + 4),
    ));

    add(CircleHitbox());
  }

  void move(Vector2 direction, double dt) {
    if (direction.isZero()) return;
    final delta = direction.normalized() * speed * dt;
    position += delta;
    position.clamp(
      Vector2(size.x / 2, size.y / 2),
      gameRef.size - Vector2(size.x / 2, size.y / 2),
    );
  }
}
