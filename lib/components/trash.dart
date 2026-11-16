import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../levels/level_data.dart';

class Trash extends PositionComponent with CollisionCallbacks {
  final TrashType type;
  final Random _random = Random();

  Trash({required Vector2 position, TrashType? type})
      : type = type ?? TrashType.values[Random().nextInt(TrashType.values.length)],
        super(
          position: position,
          size: Vector2(36, 36),
          anchor: Anchor.center,
        );

  Color get color {
    switch (type) {
      case TrashType.plastic:
        return const Color(0xFF42A5F5); // Bright blue
      case TrashType.metal:
        return const Color(0xFF78909C); // Silver grey
      case TrashType.paper:
        return const Color(0xFFFFB74D); // Warm orange/yellow
      case TrashType.organic:
        return const Color(0xFF66BB6A); // Green
    }
  }

  String get emoji {
    switch (type) {
      case TrashType.plastic:
        return '🧻'; // bottle
      case TrashType.metal:
        return '🥤'; // can
      case TrashType.paper:
        return '📄'; // page
      case TrashType.organic:
        return '🍎'; // apple
    }
  }

  String get label {
    switch (type) {
      case TrashType.plastic:
        return 'PLASTIC';
      case TrashType.metal:
        return 'METAL';
      case TrashType.paper:
        return 'PAPER';
      case TrashType.organic:
        return 'ORGANIC';
    }
  }

  @override
  Future<void> onLoad() async {
    // Main body - clearly colored
    add(CircleComponent(
      radius: 16,
      paint: Paint()..color = color,
      anchor: Anchor.center,
      position: size / 2,
    ));

    // White border for visibility
    add(CircleComponent(
      radius: 17,
      paint: Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
      anchor: Anchor.center,
      position: size / 2,
    ));

    // Emoji on top for instant recognition
    add(TextComponent(
      text: emoji,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18),
      ),
    ));

    // Small label underneath for clarity
    add(TextComponent(
      text: label,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y + 2),
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.6), blurRadius: 2),
          ],
        ),
      ),
    ));

    add(CircleHitbox());
  }
}
