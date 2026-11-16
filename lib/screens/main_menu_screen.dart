import 'package:flutter/material.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF81C784),
              Color(0xFF4FC3F7),
              Color(0xFFBA68C8),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '🌍',
                    style: TextStyle(fontSize: 72),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Eco-Warrior',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                  const Text(
                    'Restore the Earth',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Clean • Recycle • Plant • Protect',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  _MenuButton(
                    label: 'Play Game',
                    icon: Icons.play_arrow_rounded,
                    color: const Color(0xFFFFCA28),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    label: 'Settings',
                    icon: Icons.settings_rounded,
                    color: const Color(0xFF42A5F5),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Made for young eco-heroes ✨',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 8,
        ),
      ),
    );
  }
}
