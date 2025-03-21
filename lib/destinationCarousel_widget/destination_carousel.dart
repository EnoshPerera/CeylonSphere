import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DestinationCarousel extends StatefulWidget {
  const DestinationCarousel({super.key});

  @override
  State<DestinationCarousel> createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<DestinationInfo> _destinations = const [
    DestinationInfo(
      imagePath: 'assets/Kandy.jpg',
      title: 'Kandy',
      location: 'Kandy, Sri Lanka',
      initialLikes: 8,
    ),
    DestinationInfo(
      imagePath: 'assets/Colombo1.jpg',
      title: 'Colombo Sri Lanka',
      location: 'Colombo, Sri Lanka',
      initialLikes: 14,
    ),
    DestinationInfo(
      imagePath: 'assets/Sigiriya.jpg',
      title: 'Sigiriya',
      location: 'Sigiriya, Sri Lanka',
      initialLikes: 20,
    ),
    DestinationInfo(
      imagePath: 'assets/Hiking.jpg',
      title: 'Galle Fort',
      location: 'Galle, Sri Lanka',
      initialLikes: 15,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int page = _pageController.page?.round() ?? 0;
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Travel Destinations',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _destinations.length,
            itemBuilder: (context, index) {
              return SingleDestinationCard(info: _destinations[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _destinations.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Colors.black
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DestinationInfo {
  final String imagePath;
  final String title;
  final String location;
  final int initialLikes;

  const DestinationInfo({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.initialLikes,
  });
}

class SingleDestinationCard extends StatefulWidget {
  final DestinationInfo info;

  const SingleDestinationCard({
    super.key,
    required this.info,
  });

  @override
  State<SingleDestinationCard> createState() => _SingleDestinationCardState();
}

class _SingleDestinationCardState extends State<SingleDestinationCard> {
  late int likes;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    likes = widget.info.initialLikes;
    isLiked = false;
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likes--;
      } else {
        likes++;
      }
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => DestinationScreen(
              imagePath: widget.info.imagePath,
              title: widget.info.title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: Image.asset(
                  widget.info.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              // Bottom text overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.info.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.info.location,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: toggleLike,
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red[300],
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('$likes'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinationImage extends StatelessWidget {
  final String imagePath;
  final String title;

  const DestinationImage({
    required this.imagePath,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                DestinationScreen(imagePath: imagePath, title: title),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: 180,
                height: 140,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinationScreen extends StatelessWidget {
  final String imagePath;
  final String title;

  const DestinationScreen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: Center(
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
