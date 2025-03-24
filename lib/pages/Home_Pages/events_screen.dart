import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<SriLankanEvent> _events = [
    SriLankanEvent(
      title: 'Kandy Esala Perahera',
      timeframe: 'July-August',
      location: 'Kandy',
      description:
          'The Kandy Esala Perahera (Festival of the Tooth) is one of Sri Lanka\'s most vibrant and spectacular festivals. This historical procession honors the Sacred Tooth Relic of Buddha, featuring traditional dancers, fire performers, whip-dancers, and beautifully adorned elephants. The festival ends with the traditional Diya-kepeema ritual, a water cutting ceremony at the Mahaweli River.',
      imageUrl: 'assets/kandy_perahera.jpg',
      tags: ['Cultural', 'Religious', 'UNESCO'],
      highlights: [
        'Over 100 magnificently adorned elephants',
        'Traditional Kandyan dancers and drummers',
        'Fire-dancers performing breathtaking routines',
        'Opportunity to witness sacred Buddhist rituals'
      ],
    ),
    SriLankanEvent(
      title: 'Vesak Poya',
      timeframe: 'May (Full Moon)',
      location: 'Nationwide',
      description:
          'Vesak celebrates the birth, enlightenment, and passing of Lord Buddha. During this Buddhist festival of lights, the entire country is illuminated with colorful lanterns, pandals (large illuminated structures depicting Buddhist stories), and thousands of oil lamps. Devotees visit temples, observe sil (meditation), and participate in charitable activities. Free food stalls called "Dansal" are set up across the country.',
      imageUrl: 'assets/vesak.jpg',
      tags: ['Religious', 'National Holiday', 'Buddhist'],
      highlights: [
        'Beautifully illuminated streets with handmade lanterns',
        'Massive pandals depicting stories from Buddha\'s life',
        'Free food and beverage stalls across the country',
        'Special devotional songs and ceremonies at temples'
      ],
    ),
    SriLankanEvent(
      title: 'Sinhala and Tamil New Year',
      timeframe: 'April 13-14',
      location: 'Nationwide',
      description:
          'The Sinhala and Tamil New Year marks the end of the harvest season and the beginning of the new solar year. This national celebration sees families engaging in various traditional rituals and customs at auspicious times. People wear new clothes, prepare special foods like kiribath (milk rice), exchange gifts, and participate in traditional games like pillow fights and greasy pole climbing.',
      imageUrl: 'assets/sinhala_tamil_new_year.jpg',
      tags: ['Cultural', 'National Holiday', 'Family'],
      highlights: [
        'Traditional New Year games and competitions',
        'Special New Year feasts with traditional delicacies',
        'Cultural rituals performed at auspicious times',
        'Community celebrations and entertainment programs'
      ],
    ),
    SriLankanEvent(
      title: 'Poson Poya',
      timeframe: 'June (Full Moon)',
      location: 'Anuradhapura & Nationwide',
      description:
          'Poson commemorates the introduction of Buddhism to Sri Lanka in the 3rd century BCE. The main celebrations take place in Anuradhapura, particularly around Mihintale, where Arhant Mahinda (son of Emperor Ashoka) first preached Buddhism to King Devanampiyatissa. White-clothed pilgrims climb the 1,840 steps to Mihintale\'s summit, while dansalas (alms-giving stalls) offer free food and drinks.',
      imageUrl: 'assets/vesak.jpg',
      tags: ['Religious', 'Pilgrimage', 'Buddhist'],
      highlights: [
        'Pilgrimage to Mihintale, the cradle of Sri Lankan Buddhism',
        'Illuminated temples and stupas across the island',
        'Religious sermons and meditation programs',
        'Cultural performances depicting the arrival of Buddhism'
      ],
    ),
    SriLankanEvent(
      title: 'Thai Pongal',
      timeframe: 'January 14-17',
      location: 'Northern & Eastern Provinces',
      description:
          'Thai Pongal is a Tamil harvest festival dedicated to the Sun God. Families gather to prepare "pongal" - a sweet rice dish cooked in a clay pot until it overflows, symbolizing abundance and prosperity. Homes are decorated with kolam (colorful rice flour designs), and cattle are honored during Maatu Pongal, acknowledging their crucial role in agriculture.',
      imageUrl: 'assets/pongal.jpg',
      tags: ['Cultural', 'Hindu', 'Harvest'],
      highlights: [
        'Traditional pongal preparation ceremonies',
        'Beautifully decorated homes with kolam art',
        'Special prayers and rituals for prosperity',
        'Cattle worship during Maatu Pongal'
      ],
    ),
    SriLankanEvent(
      title: 'Kataragama Festival',
      timeframe: 'July-August',
      location: 'Kataragama',
      description:
          'The Kataragama Festival honors the deity Kataragama, revered by Buddhists, Hindus, Muslims, and indigenous Vedda people. The two-week festival features fire-walking ceremonies, where devotees walk across beds of burning coal to demonstrate their faith. Pilgrims engage in acts of self-mortification, while the nightly perahera procession showcases dancers, musicians, and decorated elephants.',
      imageUrl: 'assets/kataragama.jpg',
      tags: ['Religious', 'Multi-faith', 'Pilgrimage'],
      highlights: [
        'Dramatic fire-walking ceremonies testing devotees\' faith',
        'Colorful nightly processions with traditional performances',
        'Unique multi-faith worship traditions',
        'Sacred bathing rituals in the Menik Ganga river'
      ],
    ),
    SriLankanEvent(
      title: 'Nallur Festival',
      timeframe: 'August-September',
      location: 'Jaffna',
      description:
          'The Nallur Festival is a 25-day celebration at the Nallur Kandaswamy Temple, one of the most significant Hindu temples in Jaffna. Dedicated to Lord Murugan (Skanda), the festival features daily rituals, music, dance performances, and chariot processions. The highlight is Theertha Thiruvizha (water-cutting ceremony) and Ther Thiruvizha (chariot festival), where thousands pull a massive ornate chariot through the streets.',
      imageUrl: 'assets/nallur.jpg',
      tags: ['Hindu', 'Cultural', 'Northern'],
      highlights: [
        'Magnificent golden chariot procession through Jaffna streets',
        'Traditional Bharatanatyam and Carnatic music performances',
        'Colorful religious ceremonies spanning 25 days',
        'Unique Northern Sri Lankan cultural showcase'
      ],
    ),
    SriLankanEvent(
      title: 'Adam\'s Peak Pilgrimage Season',
      timeframe: 'December-May',
      location: 'Central Highlands',
      description:
          'Adam\'s Peak (Sri Pada) is a sacred mountain venerated by Buddhists, Hindus, Muslims, and Christians alike. During the pilgrimage season, thousands climb the 5,500 steps to the summit overnight to witness the spectacular sunrise and the mysterious triangular shadow cast by the peak. The mountain houses what is believed to be the footprint of Buddha, Shiva, Adam, or St. Thomas depending on faith traditions.',
      imageUrl: 'assets/adams_peak.jpg',
      tags: ['Pilgrimage', 'Multi-faith', 'Adventure'],
      highlights: [
        'Breathtaking sunrise views from the sacred summit',
        'Unique shadow phenomenon at dawn',
        'Traditional bells rung by pilgrims completing the journey',
        'Multi-faith worship at the sacred footprint shrine'
      ],
    ),
    SriLankanEvent(
      title: 'Colombo International Film Festival',
      timeframe: 'November',
      location: 'Colombo',
      description:
          'The Colombo International Film Festival showcases international and Sri Lankan cinema, featuring premieres, director talks, and workshops. This growing cultural event attracts filmmakers and cinema enthusiasts from across Asia and beyond, promoting Sri Lankan cinema on the global stage while exposing local audiences to diverse international films.',
      imageUrl: 'assets/film_festival.jpg',
      tags: ['Cultural', 'Arts', 'International'],
      highlights: [
        'Premieres of acclaimed international films',
        'Showcases of new Sri Lankan cinema talent',
        'Workshops and masterclasses with renowned filmmakers',
        'Red carpet events and filmmaker Q&A sessions'
      ],
    ),
    SriLankanEvent(
      title: 'Galle Literary Festival',
      timeframe: 'January',
      location: 'Galle Fort',
      description:
          'Set within the historic UNESCO World Heritage Galle Fort, this prestigious literary festival brings together international and local authors, poets, and intellectuals. The festival features book launches, panel discussions, workshops, and cultural performances against the backdrop of colonial architecture and Indian Ocean views.',
      imageUrl: 'assets/galle_lit_fest.jpg',
      tags: ['Cultural', 'Literary', 'International'],
      highlights: [
        'Intimate readings and discussions with acclaimed authors',
        'Writing workshops and creative sessions',
        'Historical walking tours of Galle Fort',
        'Fusion of literature, food, music, and art'
      ],
    ),
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Religious',
    'Cultural',
    'Hindu',
    'Buddhist',
    'International'
  ];

  List<SriLankanEvent> get _filteredEvents {
    if (_selectedCategory == 'All') {
      return _events;
    } else {
      return _events
          .where((event) => event.tags.contains(_selectedCategory))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sri Lankan Events & Festivals'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeaderImage(),
            const SizedBox(height: 16),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredEvents.isEmpty
                  ? const Center(
                      child: Text('No events found for this category'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(_filteredEvents[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      // height: 130,
      // width: double.infinity,
      // decoration: BoxDecoration(
      //   color: const Color(0xFF003734),
      //   image: DecorationImage(
      //     image: const AssetImage('assets/events/header.jpg'),
      //     fit: BoxFit.cover,
      //     colorFilter: ColorFilter.mode(
      //       Colors.black.withOpacity(0.3),
      //       BlendMode.darken,
      //     ),
      //   ),
      //),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: _selectedCategory == _categories[index]
                  ? const Color(0xFF003734)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              minSize: 30,
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: _selectedCategory == _categories[index]
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedCategory = _categories[index];
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(SriLankanEvent event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with date overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    event.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          CupertinoIcons.photo,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      event.timeframe,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003734),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.location_solid,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.location,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              CupertinoIcons.forward,
                              color: Color(0xFFFF9800),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Details',
                              style: TextStyle(
                                color: Color(0xFFFF9800),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: event.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTagColor(tag).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getTagColor(tag),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Religious':
        return Colors.purple;
      case 'Cultural':
        return Colors.blue;
      case 'Buddhist':
        return Colors.orange;
      case 'Hindu':
        return Colors.red;
      case 'National Holiday':
        return Colors.green;
      case 'Pilgrimage':
        return Colors.teal;
      case 'Multi-faith':
        return Colors.indigo;
      case 'International':
        return Colors.pink;
      case 'Arts':
        return Colors.cyan;
      case 'Literary':
        return Colors.brown;
      case 'UNESCO':
        return Colors.deepPurple;
      case 'Family':
        return Colors.lightBlue;
      case 'Adventure':
        return Colors.deepOrange;
      case 'Northern':
        return Colors.lightGreen;
      case 'Harvest':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}

class EventDetailScreen extends StatelessWidget {
  final SriLankanEvent event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(event.title),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image
              Image.asset(
                event.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      CupertinoIcons.photo,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event info header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            event.timeframe,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          CupertinoIcons.location_solid,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003734),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: event.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getTagColor(tag).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 13,
                              color: _getTagColor(tag),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Description
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Highlights
                    const Text(
                      'Highlights',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...event.highlights.map((highlight) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              color: Color(0xFFFF9800),
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                highlight,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                    // Travel tips section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                CupertinoIcons.info_circle_fill,
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Travel Tips',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '• Book accommodation well in advance as it gets busy during festival periods\n'
                            '• Dress modestly when visiting religious sites (shoulders and knees covered)\n'
                            '• Stay hydrated and wear sunscreen for outdoor festivities\n'
                            '• Consider local transportation options as traffic may be congested\n'
                            '• Respect local customs and traditions while participating',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Share and Save buttons
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // Share functionality would go here
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: const Text('Share Event'),
                                  content: const Text(
                                      'Share this event with friends and family!'),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.share,
                                    color: Colors.black87,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // Add to calendar functionality would go here
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: const Text('Add to Calendar'),
                                  content: const Text(
                                      'This event has been added to your travel calendar.'),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.calendar_badge_plus,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add to Calendar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Religious':
        return Colors.purple;
      case 'Cultural':
        return Colors.blue;
      case 'Buddhist':
        return Colors.orange;
      case 'Hindu':
        return Colors.red;
      case 'National Holiday':
        return Colors.green;
      case 'Pilgrimage':
        return Colors.teal;
      case 'Multi-faith':
        return Colors.indigo;
      case 'International':
        return Colors.pink;
      case 'Arts':
        return Colors.cyan;
      case 'Literary':
        return Colors.brown;
      case 'UNESCO':
        return Colors.deepPurple;
      case 'Family':
        return Colors.lightBlue;
      case 'Adventure':
        return Colors.deepOrange;
      case 'Northern':
        return Colors.lightGreen;
      case 'Harvest':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}

class SriLankanEvent {
  final String title;
  final String timeframe;
  final String location;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final List<String> highlights;

  SriLankanEvent({
    required this.title,
    required this.timeframe,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.highlights,
  });
}
