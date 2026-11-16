import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame/components.dart';
import '../game/eco_warrior_game.dart';
import '../levels/level_data.dart';
import 'pause_menu_screen.dart';

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
  static const double joystickRadius = 58;

  @override
  void initState() {
    super.initState();
    game = EcoWarriorGame(
      level: widget.level,
      onPause: () {},
      onLevelComplete: _onLevelComplete,
      onGameOver: _onGameOver,
    );
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('🎉 Mission Complete!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You restored ${widget.level.name}!'),
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

  void _onGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('😢 Oh no!', textAlign: TextAlign.center),
        content: const Text('You took too much damage. Try again, Eco-Warrior!'),
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

    setState(() {
      _knobPosition = _joystickOrigin! + clamped;
    });

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
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),

          // Pause
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: _RoundButton(
              icon: Icons.pause_rounded,
              color: Colors.orangeAccent,
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

          // Joystick
          Positioned(
            left: 20,
            bottom: 28,
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
                        color: Colors.white.withOpacity(0.22),
                        border: Border.all(color: Colors.white60, width: 2.5),
                      ),
                    ),
                    if (_knobPosition != null && _joystickOrigin != null)
                      Positioned(
                        left: (_knobPosition!.dx - 24).clamp(0, joystickRadius * 2 - 48),
                        top: (_knobPosition!.dy - 24).clamp(0, joystickRadius * 2 - 48),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // HAND button - primary action (pick / deliver)
          Positioned(
            right: 18,
            bottom: 140,
            child: Column(
              children: [
                _RoundButton(
                  icon: Icons.back_hand_rounded,
                  color: const Color(0xFFFFA726),
                  size: 68,
                  onTap: () => game.tryPickTrash(),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PICK / DROP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
                  ),
                ),
              ],
            ),
          ),

          // Plant tree button
          Positioned(
            right: 18,
            bottom: 55,
            child: Column(
              children: [
                _RoundButton(
                  icon: Icons.park_rounded,
                  color: const Color(0xFF66BB6A),
                  size: 60,
                  onTap: () => game.plantTree(),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PLANT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
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
    this.size = 54,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: const [
            BoxShadow(color: Colors.black35, blurRadius: 10, offset: Offset(0, 4)),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.48),
      ),
    );
  }
}
