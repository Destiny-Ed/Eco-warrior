import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame/components.dart';
import '../game/eco_warrior_game.dart';
import '../levels/level_data.dart';
import 'pause_menu_screen.dart';
import 'tutorial_overlay.dart';

class GameScreen extends StatefulWidget {
  final LevelConfig level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late EcoWarriorGame game;
  Offset? _joystickOrigin;
  Offset? _knobPosition;
  static const double joystickRadius = 56;
  bool _showTutorial = false;
  bool _tutorialChecked = false;

  @override
  void initState() {
    super.initState();
    _checkTutorial();
  }

  Future<void> _checkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('tutorial_seen') ?? false;
    if (!seen && widget.level.id == 1) {
      setState(() {
        _showTutorial = true;
        _tutorialChecked = true;
      });
    } else {
      setState(() => _tutorialChecked = true);
      _initGame();
    }
  }

  void _initGame() {
    final topPadding = MediaQuery.of(context).padding.top;
    game = EcoWarriorGame(
      level: widget.level,
      topSafePadding: topPadding,
      onPause: () {},
      onLevelComplete: _onLevelComplete,
      onGameOver: _onGameOver,
      onTimeUp: _onTimeUp,
    );
  }

  Future<void> _finishTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_seen', true);
    setState(() => _showTutorial = false);
    _initGame();
  }

  Future<void> _onLevelComplete() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('completed_levels') ?? [];
    if (!list.contains(widget.level.id.toString())) {
      list.add(widget.level.id.toString());
      await prefs.setStringList('completed_levels', list);
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Mission Complete', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You restored ${widget.level.name}!'),
            const SizedBox(height: 8),
            Text('Score: ${game.score}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Text(
              widget.level.tip,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Levels'),
          ),
        ],
      ),
    );
  }

  void _onGameOver() => _showFailDialog('You ran out of hearts. Try again!');
  void _onTimeUp() => _showFailDialog('Time ran out. Try again!');

  void _showFailDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Mission Failed', textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              game.reset();
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }

  void _updateJoystick(Offset localPos) {
    if (_joystickOrigin == null) return;
    final delta = localPos - _joystickOrigin!;
    final distance = delta.distance;
    final clamped = distance > joystickRadius
        ? Offset.fromDirection(delta.direction, joystickRadius)
        : delta;

    setState(() => _knobPosition = _joystickOrigin! + clamped);
    game.joystickDirection = Vector2(clamped.dx / joystickRadius, clamped.dy / joystickRadius);
  }

  void _resetJoystick() {
    setState(() {
      _joystickOrigin = null;
      _knobPosition = null;
    });
    game.joystickDirection = Vector2.zero();
  }

  @override
  Widget build(BuildContext context) {
    if (!_tutorialChecked) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_showTutorial) {
      return TutorialOverlay(onFinished: _finishTutorial);
    }

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),

          // Pause button – top right, clear of timer
          Positioned(
            top: MediaQuery.of(context).padding.top + 6,
            right: 10,
            child: _RoundButton(
              icon: Icons.pause_rounded,
              color: const Color(0xFFFFA726),
              size: 42,
              onTap: () {
                game.isPaused = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PauseMenuScreen(
                      game: game,
                      onResume: () => setState(() => game.isPaused = false),
                    ),
                  ),
                );
              },
            ),
          ),

          // Joystick – raised so it does not overlap the bins
          Positioned(
            left: 18,
            bottom: 130,
            child: GestureDetector(
              onPanStart: (d) {
                setState(() {
                  _joystickOrigin = d.localPosition;
                  _knobPosition = d.localPosition;
                });
              },
              onPanUpdate: (d) => _updateJoystick(d.localPosition),
              onPanEnd: (_) => _resetJoystick(),
              child: SizedBox(
                width: joystickRadius * 2,
                height: joystickRadius * 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: joystickRadius * 2,
                      height: joystickRadius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.18),
                        border: Border.all(color: Colors.white54, width: 2),
                      ),
                    ),
                    if (_knobPosition != null && _joystickOrigin != null)
                      Positioned(
                        left: (_knobPosition!.dx - 22).clamp(0, joystickRadius * 2 - 44),
                        top: (_knobPosition!.dy - 22).clamp(0, joystickRadius * 2 - 44),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons – right side, clean
          Positioned(
            right: 16,
            bottom: 150,
            child: Column(
              children: [
                _RoundButton(
                  icon: Icons.back_hand_rounded,
                  color: const Color(0xFFFFA726),
                  size: 62,
                  onTap: () => game.tryPickTrash(),
                ),
                const SizedBox(height: 6),
                const Text(
                  'PICK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 16,
            bottom: 70,
            child: Column(
              children: [
                _RoundButton(
                  icon: Icons.park_rounded,
                  color: const Color(0xFF43A047),
                  size: 56,
                  onTap: () => game.plantTree(),
                ),
                const SizedBox(height: 6),
                const Text(
                  'PLANT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const _RoundButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black38,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: Colors.white, size: size * 0.48),
        ),
      ),
    );
  }
}
