import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../levels/level_data.dart';
import 'story_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  Set<int> completed = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('completed_levels') ?? [];
    setState(() {
      completed = list.map(int.parse).toSet();
    });
  }

  bool _isUnlocked(int id) {
    if (id == 1) return true;
    return completed.contains(id - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFB3E5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Choose Your Mission',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: allLevels.length,
                  itemBuilder: (context, index) {
                    final level = allLevels[index];
                    final unlocked = _isUnlocked(level.id);
                    final done = completed.contains(level.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Material(
                        elevation: unlocked ? 4 : 1,
                        borderRadius: BorderRadius.circular(20),
                        color: unlocked ? Colors.white : Colors.grey.shade200,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: unlocked
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StoryScreen(level: level),
                                    ),
                                  ).then((_) => _loadProgress());
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: unlocked
                                        ? level.accentColor.withOpacity(0.2)
                                        : Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      unlocked ? level.emoji : '🔒',
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level ${level.id}: ${level.name}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: unlocked ? Colors.black87 : Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        level.goalDescription,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: unlocked ? Colors.black54 : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (done)
                                  const Icon(Icons.check_circle, color: Colors.green, size: 28),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tip: Complete a level to unlock the next one!',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
