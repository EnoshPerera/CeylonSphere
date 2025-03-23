import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/destination2.dart';
import 'gallery_page.dart';
import 'package:audioplayers/audioplayers.dart';

class DestinationDetailPage extends StatefulWidget {
  final String destinationName;
  final String imagePath;
  final String description;
  final String country;

  const DestinationDetailPage({
    super.key,
    required this.destinationName,
    required this.imagePath,
    required this.description,
    required this.country,
  });

  @override
  _DestinationDetailPageState createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage>with SingleTickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String audioFile;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        setState(() {
          _isAppBarExpanded = _scrollController.offset < 200;
        });
      }
    });

    // Get the audio file for the current destination
    final destinations = DestinationsData.getDestinations();
    final currentDestination = destinations.firstWhere(
          (d) => d.name == widget.destinationName,
      orElse: () => destinations.first,
    );
    audioFile = currentDestination.audioFile;

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Adjust this to match your audio duration
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    // Listen to audio player state changes
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        _animationController.reset();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAudio() async {
    try {
      if (isPlaying) {
        await audioPlayer.stop();
        _animationController.reset();
        setState(() => isPlaying = false);
      } else {
        await audioPlayer.play(AssetSource(audioFile));
        _animationController.forward(from: 0);
        setState(() => isPlaying = true);
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Collapsing App Bar with Parallax Effect
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image with Parallax
                    Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                    // Gradient Overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                title: _isAppBarExpanded
                    ? null
                    : Text(
                  widget.destinationName,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(CupertinoIcons.back, color: Colors.white),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.destinationName,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.country,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Quick Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickAction(
                              icon: CupertinoIcons.map,
                              label: 'Map',
                              onTap: () {},
                            ),
                            _buildQuickAction(
                              icon: CupertinoIcons.camera,
                              label: 'Gallery',
                              onTap: () {
                                // Find the current destination in the list to get its gallery images
                                final destinations = DestinationsData.getDestinations();
                                final currentDestination = destinations.firstWhere(
                                      (d) => d.name == widget.destinationName,
                                  orElse: () => destinations.first,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GalleryPage(
                                      destinationName: widget.destinationName,
                                      galleryImages: currentDestination.galleryImages,
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildQuickAction(

                              icon: isPlaying ? CupertinoIcons.stop : CupertinoIcons.volume_up,
                              label: isPlaying ? 'Stop' : 'Audio',
                              onTap: playAudio,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Description Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // About Section Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                CupertinoIcons.info,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // About Content Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Text(
                                widget.description.split("Why Visit")[0],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              if (isPlaying)
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.green.withOpacity(0.2),
                                            Colors.transparent,
                                          ],
                                          stops: [
                                            _animation.value,
                                            _animation.value + 0.1,
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: Text(
                                        widget.description.split("Why Visit")[0],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          height: 1.6,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Why Visit Section Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                CupertinoIcons.lightbulb,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Why Visit?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Why Visit Points
                        ...widget.description
                            .split("Why Visit")[1]
                            .split("✅")
                            .where((s) => s.trim().isNotEmpty)
                            .map((point) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      point.split('–')[0].trim(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                      ),
                                    ),
                                    if (point.contains('–'))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          point.split('–')[1].trim(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                            .toList(),
                      ],
                    ),
                  ),

                  // Nearby Services Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_city,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Nearby Services',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildServiceCard(
                                icon: CupertinoIcons.map,
                                title: 'Map',
                                count: '12',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add bottom padding to prevent content from being covered by the navigation bar
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.smart_toy_outlined, color: Colors.green),
            label: const Text(
              'Travel Bot',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String count,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$count nearby',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Add a static list of sample destinations
class DestinationsData {
  static List<Destination> getDestinations() {
    return [
      Destination(
        name: 'Sigiriya',
        country: 'Sri Lanka',
        imagePath: 'assets/Sigiriya.jpg',
        description:
        "Rising 200 meters above the lush jungles of Sri Lanka, Sigiriya (Lion Rock) is an awe-inspiring ancient fortress and UNESCO World Heritage Site. Built in the 5th century AD by King Kashyapa, this massive rock citadel is famous for its stunning frescoes, intricate gardens, and the legendary Mirror Wall.\n At the summit of Sigiriya lie the ruins of an ancient royal palace, offering breathtaking 360-degree views of the surrounding forests and villages. The climb to the top is an adventure in itself, passing through the Lion's Paw Entrance and ancient stairways carved into the rock.\n\nWhy Visit Sigiriya?\n\n✅ UNESCO World Heritage Site – Explore one of Sri Lanka's most iconic and historically significant landmarks.\n✅ Engineering Marvel – Discover the advanced ancient technology behind Sigiriya's sophisticated irrigation, landscaped gardens, and fortress design.\n✅ Timeless Frescoes – Admire the world-famous Sigiriya Maidens, beautifully painted on the rock's walls over 1,500 years ago.\n✅ Breathtaking Views – Reach the summit for unparalleled 360° panoramic views of lush jungles, villages, and distant mountains.",
        galleryImages: [
          'assets/sigiriya_gallery1.jpg',
          'assets/sigiriya_gallery2.jpg',
          'assets/sigiriya_gallery3.jpg',
          'assets/sigiriya_gallery4.jpg',
          'assets/sigiriya_gallery5.jpg',
        ],
        audioFile: 'audio/SigiriyaAudioClip.mp3',
      ),
      Destination(
        name: 'Ruwanwelisaya',
        country: 'Sri Lanka',
        imagePath: 'assets/ruwanwelisaya.jpg',
        description:
        "Standing as a symbol of Sri Lanka's deep-rooted Buddhist heritage, Ruwanwelisaya is one of the most sacred and awe-inspiring stupas in Anuradhapura. Built by King Dutugemunu in 140 B.C., this colossal white dagoba is among the tallest ancient monuments in the world, towering at 103 meters with a diameter of 290 meters.\n Surrounded by an atmosphere of devotion and serenity, Ruwanwelisaya is believed to enshrine relics of Lord Buddha, making it a key pilgrimage site. The stupa's radiant white dome, intricate carvings, and the golden pinnacle create a mesmerizing sight, especially when illuminated at night.\n\nWhy Visit Ruwanwelisaya?\n\n✅ Spiritual Significance – One of the most sacred Buddhist stupas in Sri Lanka, believed to enshrine relics of Lord Buddha.\n✅ Architectural Marvel – Admire this colossal white dagoba, showcasing ancient craftsmanship and intricate carvings.\n✅ Serene Atmosphere – Experience the tranquility and devotion of this revered pilgrimage site.\n✅ Historical Legacy – Built by King Dutugemunu in 140 B.C., symbolizing the strength and faith of ancient Sri Lanka.",
        galleryImages: [
          'assets/ruwanwelisaya_gallery1.jpg',
          'assets/ruwanwelisaya_gallery2.JPG',
          'assets/ruwanwelisaya_gallery3.jpg',
          'assets/ruwanwelisaya_gallery4.jpg',
        ],
        audioFile: 'audio/RuwanwelisayaAudioClip.mp3',
      ),
      Destination(
        name: 'Galle Fort',
        country: 'Sri Lanka',
        imagePath: 'assets/galle_fort.jpg',
        description:
        "Perched along Sri Lanka's southern coast, Galle Fort is a stunning UNESCO World Heritage Site that blends Dutch, Portuguese, and British colonial influences with Sri Lankan charm. Originally built by the Portuguese in the 16th century and later expanded by the Dutch in 1649, this historic fort is now a vibrant hub of culture, history, and breathtaking ocean views.\n Wander through its cobblestone streets, admire well-preserved colonial buildings, and explore iconic landmarks like the Galle Lighthouse, the Clock Tower, and the ancient Dutch Reformed Church. The fort's massive stone walls still stand strong, protecting the charming town inside from the crashing waves of the Indian Ocean.\n\nWhy Visit Galle Fort?\n\n✅ Rich Colonial History – Step into a UNESCO World Heritage Site where Dutch, Portuguese, and British influences blend with Sri Lankan culture.\n✅ Scenic Sunset Views – Watch the golden sun dip into the Indian Ocean from the iconic fort walls.\n✅ Charming Streets & Cafés – Wander through cobblestone streets lined with boutique shops, art galleries, and cozy cafés.\n✅ Galle Lighthouse – Visit Sri Lanka's oldest lighthouse, offering breathtaking coastal views and photo-perfect moments.",
        galleryImages: [
          'assets/galle_fort_gallery1.jpg',
          'assets/galle_fort_gallery2.jpeg',
          'assets/galle_fort_gallery3.jpg',
          'assets/galle_fort_gallery4.webp',
          'assets/galle_fort_gallery5.jpg',
          'assets/galle_fort_gallery6.jpg',
        ],
        audioFile: 'audio/GalleFortAudioClip.mp3',
      ),
      Destination(
        name: 'Temple of the Tooth',
        country: 'Sri Lanka',
        imagePath: 'assets/kandy1.jpg',
        description:
        "Located in the heart of Kandy, Sri Lanka, the Temple of the Sacred Tooth Relic (Sri Dalada Maligawa) is one of the most revered Buddhist sites in the world. It houses the sacred tooth relic of Lord Buddha, making it a place of deep spiritual significance and a UNESCO World Heritage Site. \n The temple, built within the royal palace complex, is a stunning example of traditional Kandyan architecture, adorned with intricate carvings, golden roofs, and beautiful paintings. The sacred relic is kept in a golden casket inside the temple's inner shrine, and devotees from around the world gather to offer prayers and seek blessings.\n\nWhy Visit the Temple of the Tooth Relic?\n\n✅ Spiritual Significance – Home to the Sacred Tooth Relic of Lord Buddha, making it one of the holiest Buddhist pilgrimage sites in the world.\n✅ Rich History – A UNESCO-listed temple that was once part of the royal palace complex of the Kandyan Kingdom.\n✅ Cultural Ceremonies – Experience daily rituals and witness the grand Esala Perahera festival, a vibrant procession of elephants, dancers, and drummers.\n✅ Breathtaking Architecture – Marvel at intricate wood carvings, golden embellishments, and serene temple courtyards.",
        galleryImages: [
          'assets/temple_gallery1.jpg',
          'assets/temple_gallery2.jpg',
          'assets/temple_gallery3.jpg',
          'assets/temple_gallery4.jpg',
        ],
        audioFile: 'audio/TempleOfTheToothAudioClip.mp3',
      ),
      Destination(
        name: 'Ambuluwawa',
        country: 'Sri Lanka',
        imagePath: 'assets/ambuluwawa.webp',
        description:
        "Nestled in the heart of Sri Lanka, Ambuluwawa Tower is a breathtaking multi-religious site and biodiversity complex located in Gampola, Kandy District. Rising 1,965 feet above sea level, this unique spiraling tower offers 360-degree panoramic views of misty mountains, lush green landscapes, and distant cities. \n Ambuluwawa is more than just a scenic spot—it's a symbol of religious harmony, featuring a Buddhist stupa, Hindu kovil, mosque, and a church, all coexisting within the complex. The climb up the narrow, winding staircase of the tower is thrilling, rewarding visitors with unparalleled views and a sense of adventure.\n\nWhy Visit Ambuluwawa?\n\n✅ Breathtaking Views – Enjoy panoramic 360° views of Sri Lanka's central highlands, misty mountains, and lush landscapes from the summit.\n✅ Unique Tower Design – Climb the spiraling Ambuluwawa Tower, an adrenaline-pumping ascent that rewards you with an unmatched aerial perspective.\n✅ Cultural Harmony – A rare site where Buddhist, Hindu, Islamic, and Christian structures coexist, symbolizing religious unity.\n✅ Biodiversity Complex – Discover rare plants, medicinal herbs, and diverse wildlife within this eco-friendly sanctuary.",
        galleryImages: [
          'assets/ambuluwawa_gallery1.jpg',
          'assets/ambuluwawa_gallery2.jpg',
          'assets/ambuluwawa_gallery3.jpg',
          'assets/ambuluwawa_gallery4.webp',
        ],
        audioFile: 'audio/AmbuluwawaAudioClip.mp3',
      ),
      Destination(
        name: 'Nine Arch Bridge',
        country: 'Sri Lanka',
        imagePath: 'assets/nine_arch_bridge.webp',
        description:
        "Hidden amidst the lush greenery of Ella, Sri Lanka, the Nine Arches Bridge is one of the most breathtaking architectural marvels in the country. Built entirely of brick, stone, and cement—without a single piece of steel—this historic railway bridge stands as a testament to early 20th-century engineering.\n Also known as the 'Bridge in the Sky,' this 91-meter-long structure gracefully curves through the rolling tea plantations, offering a magical sight, especially when a train crosses its towering 24-meter-high arches. The bridge was constructed during the British colonial era in 1921 and has since become a favorite spot for photographers and travelers alike.\n\nWhy Visit the Nine Arch Bridge?\n\n✅ Breathtaking Views – A stunning fusion of lush greenery, misty hills, and colonial-era architecture, making it a picture-perfect spot.\n✅ Historical Significance – Built during the British colonial period, this remarkable bridge was constructed using only brick, stone, and cement—no steel!\n✅ Scenic Train Crossings – Witness the iconic blue train gracefully curve through the nine majestic arches, creating an unforgettable sight.\n✅ Hiking & Photography – Enjoy a short scenic trek to reach the best viewpoints and capture breathtaking sunrise or sunset shots.",
        galleryImages: [
          'assets/nine_arch_gallery1.jpg',
          'assets/nine_arch_gallery2.jpg',
          'assets/nine_arch_gallery3.jpg',
          'assets/nine_arch_gallery4.jpg',
          'assets/nine_arch_gallery5.jpg',
        ],
        audioFile: 'audio/NineArchBridgeAudioClip.mp3',
      ),
    ];
  }
}
