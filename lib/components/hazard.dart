import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/eco_warrior_game.dart';
import '../levels/level_data.dart';
import 'player.dart';

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
          size: Vector2(44, 44),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    Color color;
    String emoji;

    switch (type) {
      case HazardType.smog:
        color = const Color(0xFF78909C).withOpacity(0.8);
        emoji = '🌫️';
        break;
      case HazardType.oil:
        color = const Color(0xFF212121).withOpacity(0.9);
        emoji = '⚙️';
        break;
      case HazardType.toxic:
        color = const Color(0xFF9CCC65).withOpacity(0.85);
        emoji = '☢️';
        break;
    }

    add(CircleComponent(
      radius: 20,
      paint: Paint()..color = color,
      anchor: Anchor.center,
      position: size / 2,
    ));

    // Warning border
    add(CircleComponent(
      radius: 21,
      paint: Paint()
        ..color = Colors.redAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
      anchor: Anchor.center,
      position: size / 2,
    ));

    add(TextComponent(
      text: emoji,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20),
      ),
    ));

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    position += direction * speed * dt;
    if (position.x < -60 || position.x > gameRef.size.x + 60) {
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
