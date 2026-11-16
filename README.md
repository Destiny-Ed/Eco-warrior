# Eco-Warrior: Restore the Earth 🌍

A fun, educational 2D game built with **Flutter + Flame** for children and teens!

Help the Eco-Warrior clean pollution, recycle trash, plant trees, and restore nature across multiple colorful levels.

## Features
- 🎮 Vibrant, kid-friendly graphics and UI
- 🕹️ Virtual joystick + hand-pick mechanic
- 💡 Power-ups and unlockable tools
- 🏆 Multiple levels with unique stories and goals
- 📋 Dynamic level system — easily add new levels
- ⏸️ Pause, Restart, Settings, Level Select
- 🏅 Achievements & local progress
- 🌱 Educational environmental tips

## Levels
1. **The Polluted Park** – Clean your neighborhood park
2. **Smoggy City Streets** – Fight air pollution
3. **Oily Beach Rescue** – Save the coastline
4. **Toxic Forest** – Restore the woods
5. **Earth's Final Call** – The ultimate challenge

## Getting Started

```bash
git clone https://github.com/Destiny-Ed/Eco-warrior.git
cd Eco-warrior
flutter pub get
flutter run
```

### Assets
The game currently uses colorful procedural shapes so it runs immediately.  
Replace the placeholder visuals in `assets/images/` with your own cute sprites for a more polished look (Kenney.nl has free eco/nature packs).

## Dynamic Levels
Levels are defined in `lib/levels/level_data.dart`.  
Just add a new `LevelConfig` entry and it appears in the Level Select screen automatically!

## Tech Stack
- Flutter
- Flame game engine
- SharedPreferences for progress

Made with ❤️ for young eco-heroes.
