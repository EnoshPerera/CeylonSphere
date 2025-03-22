import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  final String destinationName;
  final List<String> galleryImages;

  const GalleryPage({
    Key? key,
    required this.destinationName,
    required this.galleryImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('$destinationName Gallery'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: galleryImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Open full-screen image view when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageView(
                        imagePath: galleryImages[index],
                        imageIndex: index,
                        totalImages: galleryImages.length,
                        galleryImages: galleryImages,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'gallery_image_$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      galleryImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatefulWidget {
  final String imagePath;
  final int imageIndex;
  final int totalImages;
  final List<String> galleryImages;

  const FullScreenImageView({
    Key? key,
    required this.imagePath,
    required this.imageIndex,
    required this.totalImages,
    required this.galleryImages,
  }) : super(key: key);

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.imageIndex;
    _pageController = PageController(initialPage: widget.imageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Image ${_currentIndex + 1} of ${widget.totalImages}',
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: widget.galleryImages.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Hero(
                tag: 'gallery_image_$index',
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4,
                  child: Image.asset(
                    widget.galleryImages[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

