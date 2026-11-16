import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/eco_warrior_game.dart';
import 'player.dart';

class Obstacle extends PositionComponent with HasGameRef<EcoWarriorGame>, CollisionCallbacks {
  Obstacle({required Vector2 position})
      : super(
          position: position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    add(CircleComponent(
      radius: 17,
      paint: Paint()..color = const Color(0xFFFF7043),
      anchor: Anchor.center,
      position: size / 2,
    ));
    add(CircleComponent(
      radius: 18,
      paint: Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
      anchor: Anchor.center,
      position: size / 2,
    ));
    add(TextComponent(
      text: '🚧',
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 18)),
    ));

    add(CircleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      HapticFeedback.mediumImpact();
      gameRef.hitObstacle();

      // Push player away so they cannot pass through
      final direction = (other.position - position).normalized();
      other.position += direction * 28;
    }
  }
}
