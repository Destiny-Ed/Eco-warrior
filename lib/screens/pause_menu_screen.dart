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
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Paused',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 24),
              _MenuButton(
                label: 'Resume',
                color: const Color(0xFF43A047),
                onTap: () {
                  onResume();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              _MenuButton(
                label: 'Restart',
                color: const Color(0xFFEF6C00),
                onTap: () {
                  game.reset();
                  onResume();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              _MenuButton(
                label: 'Main Menu',
                color: const Color(0xFF546E7A),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}
