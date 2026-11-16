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
    setState(() => completed = list.map(int.parse).toSet());
  }

  bool _isUnlocked(int id) => id == 1 || completed.contains(id - 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Select Mission'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B5E20),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: allLevels.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final level = allLevels[index];
          final unlocked = _isUnlocked(level.id);
          final done = completed.contains(level.id);

          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: unlocked ? 1 : 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: unlocked
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => StoryScreen(level: level)),
                      ).then((_) => _loadProgress());
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: unlocked
                            ? level.accentColor.withOpacity(0.15)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          unlocked ? level.emoji : '🔒',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level ${level.id}  •  ${level.name}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
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
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF43A047), size: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
