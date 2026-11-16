import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/eco_warrior_game.dart';
import '../levels/level_data.dart';

class Hazard extends PositionComponent with HasGameRef<EcoWarriorGame>, CollisionCallbacks {
  final HazardType type;
  final double speed;
  final Vector2 direction;

  Hazard({
    required Vector2 position,
    required this.type,
    required this.speed,
    required this.direction,
  }) : super(
          position: position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    Color color;
    switch (type) {
      case HazardType.smog:
        color = const Color(0xFF78909C).withOpacity(0.75);
        break;
      case HazardType.oil:
        color = const Color(0xFF212121).withOpacity(0.85);
        break;
      case HazardType.toxic:
        color = const Color(0xFF9CCC65).withOpacity(0.8);
        break;
    }

    add(CircleComponent(
      radius: 18,
      paint: Paint()..color = color,
      anchor: Anchor.center,
      position: size / 2,
    ));

    // Warning mark
    add(TextComponent(
      text: '!',
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    position += direction * speed * dt;
    // Remove when off screen
    if (position.x < -50 || position.x > gameRef.size.x + 50) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      gameRef.takeDamage();
      removeFromParent();
    }
  }
}
