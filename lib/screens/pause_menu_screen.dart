import 'package:flutter/material.dart';
import '../game/eco_warrior_game.dart';

class PauseMenuScreen extends StatelessWidget {
  final EcoWarriorGame game;
  final VoidCallback onResume;

  const PauseMenuScreen({
    super.key,
    required this.game,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 20, offset: Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⏸ Paused',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 28),
              _PauseButton(
                label: 'Resume',
                color: const Color(0xFFFFCA28),
                onTap: () {
                  onResume();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: 'Restart',
                color: const Color(0xFFEF5350),
                onTap: () {
                  game.reset();
                  onResume();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: 'Main Menu',
                color: Colors.white,
                textColor: Colors.black87,
                onTap: () {
                  Navigator.pop(context); // pause
                  Navigator.pop(context); // game
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _PauseButton({
    required this.label,
    required this.color,
    this.textColor = Colors.black87,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
