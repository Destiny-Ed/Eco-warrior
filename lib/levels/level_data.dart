/// Dynamic Level System
/// To add a new level simply append a new LevelConfig to [allLevels].

enum HazardType { smog, oil, toxic }

enum TrashType {
  plastic, // Blue
  metal,   // Silver/Grey
  paper,   // Yellow/Brown
  organic, // Green
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
    this.spawnInterval = const Duration(seconds: 4),
    required this.tip,
  });
}

final List<LevelConfig> allLevels = [
  LevelConfig(
    id: 1,
    name: 'The Polluted Park',
    emoji: '🌳⚠️',
    story:
        'Your neighborhood park was once full of laughter and green grass. Now plastic bottles and cans cover the ground. As a new Eco-Warrior, your first mission is simple but important: pick up trash and take it to the matching recycling bin!',
    goalDescription: 'Collect & recycle 20 pieces of trash. Plant 3 trees.',
    trashTarget: 20,
    treesToPlant: 3,
    backgroundColor: const Color(0xFF81C784),
    accentColor: const Color(0xFF4CAF50),
    initialTrash: 8,
    spawnInterval: const Duration(seconds: 3),
    tip: 'Recycling one plastic bottle can save enough energy to power a lightbulb for 3 hours!',
  ),
  LevelConfig(
    id: 2,
    name: 'Smoggy City Streets',
    emoji: '🏙️🌫️',
    story:
        'The city air is thick with smog. Cars and factories have made it hard to breathe. Move carefully, avoid the smog clouds, pick up trash and deliver it to the correct bins!',
    goalDescription: 'Recycle 30 trash items while avoiding smog. Plant 5 trees.',
    trashTarget: 30,
    treesToPlant: 5,
    backgroundColor: const Color(0xFF90A4AE),
    accentColor: const Color(0xFF78909C),
    hasHazards: true,
    hazardType: HazardType.smog,
    hazardSpeed: 50,
    initialTrash: 10,
    spawnInterval: const Duration(seconds: 3),
    tip: 'Trees are natural air filters — one mature tree can absorb 48 pounds of CO2 per year!',
  ),
  LevelConfig(
    id: 3,
    name: 'Oily Beach Rescue',
    emoji: '🏖️🛢️',
    story:
        'An oil spill has reached the beautiful beach. Sea turtles and fish are in danger. Collect the plastic and take it to the right bins before the tide brings more pollution!',
    goalDescription: 'Recycle 35 trash items. Avoid oil hazards. Plant 4 trees.',
    trashTarget: 35,
    treesToPlant: 4,
    backgroundColor: const Color(0xFF4FC3F7),
    accentColor: const Color(0xFF0288D1),
    hasHazards: true,
    hazardType: HazardType.oil,
    hazardSpeed: 35,
    initialTrash: 12,
    spawnInterval: const Duration(seconds: 2),
    tip: 'It can take up to 450 years for a plastic bottle to break down in the ocean.',
  ),
  LevelConfig(
    id: 4,
    name: 'Toxic Forest',
    emoji: '🌲💣',
    story:
        'Illegal dumping has poisoned the forest. Toxic barrels are leaking. Carefully remove the toxic waste by recycling correctly and plant trees to bring life back!',
    goalDescription: 'Recycle 40 trash and plant 8 trees while avoiding toxic waste.',
    trashTarget: 40,
    treesToPlant: 8,
    backgroundColor: const Color(0xFF66BB6A),
    accentColor: const Color(0xFF2E7D32),
    hasHazards: true,
    hazardType: HazardType.toxic,
    hazardSpeed: 45,
    initialTrash: 10,
    spawnInterval: const Duration(seconds: 3),
    tip: 'Forests are home to 80% of the world\'s land animals and plants. Protecting them protects life!',
  ),
  LevelConfig(
    id: 5,
    name: "Earth's Final Call",
    emoji: '🌍🚀',
    story:
        'This is it! Pollution has reached a critical point. Only the bravest Eco-Warrior can clean the mega-mess, recycle everything correctly, plant forests of hope, and inspire the world.',
    goalDescription: 'Recycle 50 trash, plant 12 trees, and survive the pollution waves!',
    trashTarget: 50,
    treesToPlant: 12,
    backgroundColor: const Color(0xFF26A69A),
    accentColor: const Color(0xFF00695C),
    hasHazards: true,
    hazardType: HazardType.toxic,
    hazardSpeed: 60,
    initialTrash: 15,
    spawnInterval: const Duration(seconds: 2),
    tip: 'Every action counts. You are the hero the planet needs. Keep going!',
  ),
];

LevelConfig getLevelById(int id) {
  return allLevels.firstWhere((l) => l.id == id, orElse: () => allLevels.first);
}
