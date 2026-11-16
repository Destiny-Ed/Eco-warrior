import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/eco_warrior_game.dart';
import '../levels/level_data.dart';
import 'trash.dart';

class Player extends PositionComponent with HasGameRef<EcoWarriorGame>, CollisionCallbacks {
  static const double speed = 190;

  Trash? carriedTrash; // Currently held item

  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2(52, 52),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    // Body
    add(CircleComponent(
      radius: 24,
      paint: Paint()..color = const Color(0xFF66BB6A),
      anchor: Anchor.center,
      position: size / 2,
    ));

    // Face
    add(CircleComponent(
      radius: 13,
      paint: Paint()..color = const Color(0xFFFFCC80),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 - 8),
    ));

    // Eyes
    add(CircleComponent(
      radius: 3.5,
      paint: Paint()..color = Colors.black87,
      position: Vector2(size.x / 2 - 6, size.y / 2 - 11),
    ));
    add(CircleComponent(
      radius: 3.5,
      paint: Paint()..color = Colors.black87,
      position: Vector2(size.x / 2 + 6, size.y / 2 - 11),
    ));

    // Smile
    add(RectangleComponent(
      size: Vector2(12, 3),
      paint: Paint()..color = Colors.black87,
      position: Vector2(size.x / 2 - 6, size.y / 2 - 2),
    ));

    // Eco leaf / cape
    add(CircleComponent(
      radius: 9,
      paint: Paint()..color = const Color(0xFF43A047),
      position: Vector2(size.x / 2 + 16, size.y / 2 + 6),
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

  bool get isCarrying => carriedTrash != null;

  void pickUp(Trash trash) {
    if (isCarrying) return;
    carriedTrash = trash;
    trash.removeFromParent();
  }

  void dropTrash() {
    carriedTrash = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Show carried trash above the player so it's obvious
    if (carriedTrash != null) {
      final paint = Paint()..color = carriedTrash!.color;
      canvas.drawCircle(Offset(size.x / 2, -12), 14, paint);
      // Emoji
      final textPainter = TextPainter(
        text: TextSpan(
          text: carriedTrash!.emoji,
          style: const TextStyle(fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.x / 2 - 8, -20));
    }
  }
}
