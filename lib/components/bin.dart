import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../levels/level_data.dart';

class Bin extends PositionComponent {
  final TrashType acceptsType;

  Bin({
    required Vector2 position,
    required this.acceptsType,
  }) : super(
          position: position,
          size: Vector2(70, 80),
          anchor: Anchor.center,
        );

  Color get color {
    switch (acceptsType) {
      case TrashType.plastic:
        return const Color(0xFF42A5F5);
      case TrashType.metal:
        return const Color(0xFF78909C);
      case TrashType.paper:
        return const Color(0xFFFFB74D);
      case TrashType.organic:
        return const Color(0xFF66BB6A);
    }
  }

  String get emoji {
    switch (acceptsType) {
      case TrashType.plastic:
        return '🧻';
      case TrashType.metal:
        return '🥤';
      case TrashType.paper:
        return '📄';
      case TrashType.organic:
        return '🍎';
    }
  }

  String get label {
    switch (acceptsType) {
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
    // Bin body
    add(RectangleComponent(
      size: Vector2(50, 55),
      paint: Paint()..color = color,
      position: Vector2(10, 20),
    ));

    // Lid
    add(RectangleComponent(
      size: Vector2(58, 12),
      paint: Paint()..color = color.withOpacity(0.85),
      position: Vector2(6, 12),
    ));

    // White border for clarity
    add(RectangleComponent(
      size: Vector2(52, 57),
      paint: Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
      position: Vector2(9, 19),
    ));

    // Big emoji
    add(TextComponent(
      text: emoji,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, 45),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 26),
      ),
    ));

    // Clear text label
    add(TextComponent(
      text: label,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y + 4),
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 3),
          ],
        ),
      ),
    ));
  }
}
