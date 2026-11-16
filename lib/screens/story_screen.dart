import 'package:flutter/material.dart';
import '../levels/level_data.dart';
import 'game_screen.dart';

class StoryScreen extends StatelessWidget {
  final LevelConfig level;

  const StoryScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              level.backgroundColor.withOpacity(0.9),
              level.accentColor.withOpacity(0.7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                Text(
                  level.emoji,
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 12),
                Text(
                  'Level ${level.id}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  level.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    level.story,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '✅ Goal: ${level.goalDescription}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(level: level),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: level.accentColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Text('Start Mission!', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
