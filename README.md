# Eco-Warrior: Restore the Earth 🌍

A fun, educational 2D game built with **Flutter + Flame** designed for children and teens.

Help the Eco-Warrior clean pollution, **recycle correctly**, plant trees, and restore nature across multiple colorful levels.

## How to Play (Clear Instructions)

1. **Move** using the virtual joystick (bottom-left).
2. **Pick up trash** by getting close and tapping the big orange **HAND** button.
3. The trash you are carrying appears above your head with its color + emoji.
4. **Deliver** it to the matching colored bin at the bottom of the screen:
   - 🧻 **Blue** = Plastic
   - 🥤 **Grey** = Metal
   - 📄 **Orange** = Paper
   - 🍎 **Green** = Organic
5. Tap the green **PLANT** button to plant trees when the level requires it.
6. Avoid moving hazards (smog, oil, toxic waste).

The top instruction bar always tells you what to do next.

## Features

- 🎮 Bright, kid-friendly visuals with strong color coding + emojis for instant recognition
- 🕹️ Virtual joystick + clear action buttons with labels
- 🔄 Improved recycling mechanic (pick → carry → deliver to matching bin)
- 💡 Dynamic on-screen instructions that change based on what you're holding
- 📳 Haptic feedback (vibration) on pick, correct delivery, planting, and damage
- 🏆 5 levels with unique stories, goals, and increasing challenge
- 📋 Dynamic level system — easily add new levels in one file
- ⏸️ Pause, Restart, Settings, Level Select with unlock progression
- 🌱 Educational tips on every level

## Levels

1. **The Polluted Park** – Learn the basics of recycling
2. **Smoggy City Streets** – Avoid air pollution
3. **Oily Beach Rescue** – Protect the coastline
4. **Toxic Forest** – Restore the woods
5. **Earth's Final Call** – The ultimate challenge

## Getting Started

```bash
git clone https://github.com/Destiny-Ed/Eco-warrior.git
cd Eco-warrior
flutter pub get
flutter run
```

## Adding New Levels

Edit `lib/levels/level_data.dart` and append a new `LevelConfig`.  
It will automatically appear in the Level Select screen.

## Notes on Assets

The game currently uses highly readable procedural graphics + emojis so everything is obvious without external image files.  
You can later replace the shapes with real sprites by loading them in the component `onLoad` methods.

Made with ❤️ for young eco-heroes.
