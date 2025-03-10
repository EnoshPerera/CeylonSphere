import 'package:flutter/cupertino.dart';

final List<Map<String, dynamic>> activityTypes = [
  {
    'name': 'Beach Relaxation & Water Sports',
    'image': 'assets/watersports.jpg',
    'icon': IconData(0xf06c2, fontFamily: 'MaterialIcons'),
    'details': {
      'places': [
        'Unawatuna',
        'Mirissa',
        'Bentota',
        'Arugam Bay',
        'Nilaveli',
        'Pasikuda',
        'Kalpitiya',
        'Hikkaduwa',
        'Tangalle',
      ],
      'activities': [
        'Sunbathing and swimming',
        'Snorkeling and scuba diving',
        'Whale and dolphin watching',
        'Jet skiing, kayaking, and windsurfing',
        'Kite surfing',
      ],
    }
  },
  {
    'name': 'Wildlife Safaris',
    'image': 'assets/wildLife.jpg',
    'icon': CupertinoIcons.tree, // 🏛️ Cultural Icon
    'details': {
      'places': [
        'Yala National Park',
        'Udawalawe National Park',
        'Wilpattu National Park',
        'Minneriya National Park',
        'Sinharaja Forest Reserve',
        'Kumana National Park'
      ],
      'activities': [
        'Spotting leopards, elephants, and sloth bears ',
        'Birdwatching ',
        'Elephant sightings ',
        'Jungle trekking and nature walks ',
      ],
    }
  },
  {
    'name': 'Cultural & Historical Exploration',
    'image': 'assets/cultural.jpg',
    'icon': CupertinoIcons.book, // 🏛️ Cultural Icon
    'details': {
      'places': [
        'Anuradhapura',
        'Polonnaruwa',
        'Sigiriya',
        'Kandy',
        'Galle',
        'Dambulla',
        'Colombo'
      ],
      'activities': [
        'Visiting ancient temples and stupas',
        'Exploring the Sigiriya Rock Fortress',
        'Touring the Temple of the Tooth Relic ',
        'Walking through the Galle Fort',
        'Discovering cave temples',
      ],
    }
  },
  {
    'name': 'Hiking & Trekking',
    'image': 'assets/Hiking.jpg',
    'icon': CupertinoIcons.map, // 🏔️ Hiking Icon
    'details': {
      'places': [
        'Adam’s Peak (Sri Pada)',
        'Knuckles Mountain Range',
        'Horton Plains National Park',
        'Ella',
        'Sinharaja Rainforest'
      ],
      'activities': [
        'Climbing Adam’s Peak for sunrise',
        'Hiking to World’s End in Horton Plains',
        'Trekking through tea plantations ',
        'Exploring the Knuckles Mountain Range',
      ],
    }
  },
  {
    'name': 'Nightlife & Entertainment',
    'image': 'assets/nightLife.jpg',
    'icon': CupertinoIcons.music_note, // 🎵 Nightlife Icon
    'details': {
      'places': ['Colombo', 'Mirissa', 'Unawatuna', 'Hikkaduwa'],
      'activities': [
        'Enjoying beach parties and nightclubs',
        'Experiencing live music and cultural shows',
      ],
    }
  },
  {
    'name': 'Kite Surfing',
    'image': 'assets/KiteSurfing.jpg',
    'icon': CupertinoIcons.waveform,
    'details': {
      'places': ['Kalpitiya', 'Mirissa', 'Unawatuna', 'Hikkaduwa'],
      'activities': [
        'KiteSurfing',
      ],
    }
  },
];
