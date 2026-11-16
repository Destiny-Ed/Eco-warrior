import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onFinished;

  const TutorialOverlay({super.key, required this.onFinished});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int step = 0;

  final List<_TutorialStep> steps = [
    _TutorialStep(
      emoji: '🕹️',
      title: 'Move Around',
      body: 'Use the joystick on the bottom-left to move your Eco-Warrior around the map.',
    ),
    _TutorialStep(
      emoji: '🤚',
      title: 'Pick Up Trash',
      body: 'Get close to colorful trash and tap the big orange HAND button to pick it up. You can only carry one item at a time.',
    ),
    _TutorialStep(
      emoji: '🗑️',
      title: 'Recycle Correctly',
      body: 'Take the trash to the matching colored bin at the bottom:\n\n🧻 Blue = Plastic\n🥤 Grey = Metal\n📄 Orange = Paper\n🍎 Green = Organic',
    ),
    _TutorialStep(
      emoji: '🌳',
      title: 'Plant Trees & Watch the Timer',
      body: 'Tap the green PLANT button to grow trees when the level needs them.\n\nFinish all goals before the timer reaches zero!',
    ),
    _TutorialStep(
      emoji: '⚠️',
      title: 'Avoid Hazards',
      body: 'Stay away from moving smog, oil, and toxic waste. Hitting obstacles or hazards costs points and hearts.\n\nYou\'re ready, Eco-Warrior!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final current = steps[step];
    final isLast = step == steps.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF66BB6A), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'How to Play',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 6)],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Step ${step + 1} of ${steps.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Spacer(),
                Text(current.emoji, style: const TextStyle(fontSize: 72)),
                const SizedBox(height: 20),
                Text(
                  current.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    current.body,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLast) {
                        widget.onFinished();
                      } else {
                        setState(() => step++);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isLast ? "Let's Go! 🚀" : 'Next',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (!isLast) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: widget.onFinished,
                    child: const Text(
                      'Skip Tutorial',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialStep {
  final String emoji;
  final String title;
  final String body;

  _TutorialStep({
    required this.emoji,
    required this.title,
    required this.body,
  });
}
