# Eco-Warrior: Restore the Earth 🌍

A fun, educational 2D game built with **Flutter + Flame** for children and teens.

Help the Eco-Warrior clean pollution, recycle correctly, plant trees, and restore nature across themed levels.

## How to Play

1. **Move** with the joystick (bottom-left).
2. **Pick up trash** by getting close and tapping the orange **HAND** button.
3. The trash you carry appears above your head.
4. **Deliver** it to the matching colored bin at the bottom:
   - 🧻 Blue = Plastic
   - 🥤 Grey = Metal
   - 📄 Orange = Paper
   - 🍎 Green = Organic
5. Tap **PLANT** to grow trees when required.
6. Finish the goals **before the timer runs out**.
7. Avoid hazards and orange construction obstacles (they cost points/hearts).

A first-time tutorial walks new players through everything.

## What's New

- First-time interactive tutorial overlay
- HUD safely positioned below the status bar
- Countdown timer per level (fail if time runs out)
- Smarter trash spawning (only when there are few items left on screen)
- Themed environments: neighborhood houses & people, city streets & cars, beach, forest animals, etc.
- Obstacles that reduce score when hit
- Score system + time bonus on success

## Levels

1. **The Polluted Park** (Neighborhood) – 90s
2. **Smoggy City Streets** – 110s
3. **Oily Beach Rescue** – 120s
4. **Toxic Forest** – 130s
5. **Earth's Final Call** – 150s

## Getting Started

```bash
git clone https://github.com/Destiny-Ed/Eco-warrior.git
cd Eco-warrior
flutter pub get
flutter run
```

## Adding New Levels

Edit `lib/levels/level_data.dart` and add a new `LevelConfig`. It appears automatically in Level Select.

Made with ❤️ for young eco-heroes.
