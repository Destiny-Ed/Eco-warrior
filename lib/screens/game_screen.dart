import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const double joystickRadius = 55;

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
              Navigator.pop(context); // dialog
              Navigator.pop(context); // game
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

          // Pause button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: _ActionButton(
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

          // Joystick (bottom left)
          Positioned(
            left: 24,
            bottom: 32,
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
                        color: Colors.white.withOpacity(0.25),
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
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Hand pick button (right side)
          Positioned(
            right: 20,
            bottom: 140,
            child: _ActionButton(
              icon: Icons.back_hand_rounded,
              color: const Color(0xFFFFA726),
              size: 64,
              onTap: () => game.pickNearbyTrash(),
            ),
          ),

          // Plant tree / power-up button
          Positioned(
            right: 20,
            bottom: 60,
            child: _ActionButton(
              icon: Icons.park_rounded,
              color: const Color(0xFF66BB6A),
              size: 64,
              onTap: () {
                if (widget.level.treesToPlant > 0) {
                  game.plantTree();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No trees needed in this level!')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 52,
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
            BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
