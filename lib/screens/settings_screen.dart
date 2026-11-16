import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double musicVolume = 0.7;
  double sfxVolume = 0.9;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text('Music Volume', style: TextStyle(fontWeight: FontWeight.w600)),
                    Slider(
                      value: musicVolume,
                      onChanged: (v) => setState(() => musicVolume = v),
                      activeColor: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text('Sound Effects', style: TextStyle(fontWeight: FontWeight.w600)),
                    Slider(
                      value: sfxVolume,
                      onChanged: (v) => setState(() => sfxVolume = v),
                      activeColor: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Vibration'),
                      value: vibration,
                      activeColor: Colors.green,
                      onChanged: (v) => setState(() => vibration = v),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Eco-Warrior helps kids and teens learn about protecting our planet while having fun!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
