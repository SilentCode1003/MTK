import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class AnnouncementDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String targetDate;
  final String image;
  final String type;

  const AnnouncementDetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.image,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(image);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 122, 24, 24),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.delete_outline_outlined,
                size: 30,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  color: Color.fromARGB(255, 255, 234, 234),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0, right: 25.0),
                        child: Text(
                          "$title",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // Set maxLines to 2
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // SizedBox(height: 5),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 90.0, right: 25.0),
                      //   child: Text(
                      //     "$description",
                      //     overflow: TextOverflow.ellipsis,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.normal,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0, right: 20.0),
                        child: Text(
                          "$targetDate",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 122, 24, 24)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notification_important,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$description',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imageBytes: bytes),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'imageHero',
                      child: SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List imageBytes;

  const FullScreenImage({Key? key, required this.imageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20.0),
              minScale: 0.1,
              maxScale: 4.0,
              child: Image.memory(
                imageBytes,fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OffensesDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String targetDate;
  final String type;

  const OffensesDetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 122, 24, 24),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.delete_outline_outlined,
                size: 30,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  color: Color.fromARGB(255, 255, 234, 234),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0, right: 25.0),
                        child: Text(
                          "$title",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // Set maxLines to 2
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // SizedBox(height: 5),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 90.0, right: 25.0),
                      //   child: Text(
                      //     "$description",
                      //     overflow: TextOverflow.ellipsis,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.normal,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0, right: 20.0),
                        child: Text(
                          "$targetDate",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 122, 24, 24)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notification_important,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$description',
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String targetDate;
  final String? image;
  final String? type;

  const AllDetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.image,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;

    if (image != null) {
      try {
        bytes = base64Decode(image!);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 122, 24, 24),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.delete_outline_outlined,
                size: 30,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  color: Color.fromARGB(255, 255, 234, 234),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0, right: 25.0),
                        child: Text(
                          "$title",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // Set maxLines to 2
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // SizedBox(height: 5),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 90.0, right: 25.0),
                      //   child: Text(
                      //     "$description",
                      //     overflow: TextOverflow.ellipsis,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.normal,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0, right: 20.0),
                        child: Text(
                          "$targetDate",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 122, 24, 24)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notification_important,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$description',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  if (bytes != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(imageBytes: bytes!),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
