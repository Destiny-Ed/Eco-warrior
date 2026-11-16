/// Dynamic Level System
/// To add a new level simply append a new LevelConfig to [allLevels].

enum HazardType { smog, oil, toxic }

enum TrashType {
  plastic, // Blue
  metal,   // Silver/Grey
  paper,   // Yellow/Brown
  organic, // Green
}

enum LevelTheme {
  neighborhood, // Level 1 - Park / houses
  city,         // Level 2 - Streets
  beach,        // Level 3
  forest,       // Level 4
  finalCall,    // Level 5
}

class LevelConfig {
  final int id;
  final String name;
  final String emoji;
  final String story;
  final String goalDescription;
  final int trashTarget;
  final int treesToPlant;
  final Color backgroundColor;
  final Color accentColor;
  final bool hasHazards;
  final HazardType? hazardType;
  final double hazardSpeed;
  final int initialTrash;
  final Duration spawnInterval;
  final String tip;
  final LevelTheme theme;
  final int timeLimitSeconds; // 0 = no timer

  const LevelConfig({
    required this.id,
    required this.name,
    required this.emoji,
    required this.story,
    required this.goalDescription,
    required this.trashTarget,
    this.treesToPlant = 0,
    required this.backgroundColor,
    required this.accentColor,
    this.hasHazards = false,
    this.hazardType,
    this.hazardSpeed = 40,
    this.initialTrash = 6,
    this.spawnInterval = const Duration(seconds: 6),
    required this.tip,
    required this.theme,
    this.timeLimitSeconds = 120,
  });
}

final List<LevelConfig> allLevels = [
  LevelConfig(
    id: 1,
    name: 'The Polluted Park',
    emoji: '🌳⚠️',
    story:
        'Your neighborhood park was once full of laughter and green grass. Now plastic bottles and cans cover the ground. Pick up trash and take it to the matching recycling bin!',
    goalDescription: 'Recycle 15 trash + plant 3 trees before time runs out.',
    trashTarget: 15,
    treesToPlant: 3,
    backgroundColor: const Color(0xFF81C784),
    accentColor: const Color(0xFF4CAF50),
    initialTrash: 7,
    spawnInterval: const Duration(seconds: 7),
    tip: 'Recycling one plastic bottle can save enough energy to power a lightbulb for 3 hours!',
    theme: LevelTheme.neighborhood,
    timeLimitSeconds: 90,
  ),
  LevelConfig(
    id: 2,
    name: 'Smoggy City Streets',
    emoji: '🏙️🌫️',
    story:
        'The city air is thick with smog. Avoid hazards, recycle correctly, and clean the streets so kids can play outside again!',
    goalDescription: 'Recycle 22 trash + plant 4 trees. Avoid smog.',
    trashTarget: 22,
    treesToPlant: 4,
    backgroundColor: const Color(0xFF90A4AE),
    accentColor: const Color(0xFF78909C),
    hasHazards: true,
    hazardType: HazardType.smog,
    hazardSpeed: 45,
    initialTrash: 8,
    spawnInterval: const Duration(seconds: 6),
    tip: 'Trees are natural air filters — one mature tree can absorb 48 pounds of CO2 per year!',
    theme: LevelTheme.city,
    timeLimitSeconds: 110,
  ),
  LevelConfig(
    id: 3,
    name: 'Oily Beach Rescue',
    emoji: '🏖️🛢️',
    story:
        'An oil spill has reached the beautiful beach. Collect plastic and deliver it to the right bins before the tide brings more pollution!',
    goalDescription: 'Recycle 25 trash + plant 4 trees. Avoid oil.',
    trashTarget: 25,
    treesToPlant: 4,
    backgroundColor: const Color(0xFF4FC3F7),
    accentColor: const Color(0xFF0288D1),
    hasHazards: true,
    hazardType: HazardType.oil,
    hazardSpeed: 35,
    initialTrash: 9,
    spawnInterval: const Duration(seconds: 5),
    tip: 'It can take up to 450 years for a plastic bottle to break down in the ocean.',
    theme: LevelTheme.beach,
    timeLimitSeconds: 120,
  ),
  LevelConfig(
    id: 4,
    name: 'Toxic Forest',
    emoji: '🌲💣',
    story:
        'Illegal dumping has poisoned the forest. Carefully recycle the waste and plant trees to bring life back!',
    goalDescription: 'Recycle 28 trash + plant 6 trees. Avoid toxic waste.',
    trashTarget: 28,
    treesToPlant: 6,
    backgroundColor: const Color(0xFF66BB6A),
    accentColor: const Color(0xFF2E7D32),
    hasHazards: true,
    hazardType: HazardType.toxic,
    hazardSpeed: 40,
    initialTrash: 9,
    spawnInterval: const Duration(seconds: 5),
    tip: 'Forests are home to 80% of the world\'s land animals and plants.',
    theme: LevelTheme.forest,
    timeLimitSeconds: 130,
  ),
  LevelConfig(
    id: 5,
    name: "Earth's Final Call",
    emoji: '🌍🚀',
    story:
        'Pollution has reached a critical point. Clean the mega-mess, recycle everything correctly, plant forests of hope, and finish before time runs out!',
    goalDescription: 'Recycle 35 trash + plant 8 trees. Survive the waves!',
    trashTarget: 35,
    treesToPlant: 8,
    backgroundColor: const Color(0xFF26A69A),
    accentColor: const Color(0xFF00695C),
    hasHazards: true,
    hazardType: HazardType.toxic,
    hazardSpeed: 55,
    initialTrash: 11,
    spawnInterval: const Duration(seconds: 4),
    tip: 'Every action counts. You are the hero the planet needs!',
    theme: LevelTheme.finalCall,
    timeLimitSeconds: 150,
  ),
];

LevelConfig getLevelById(int id) {
  return allLevels.firstWhere((l) => l.id == id, orElse: () => allLevels.first);
}
