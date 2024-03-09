import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class AnnouncementDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String targetDate;
  final String image;
  final String type;

  const AnnouncementDetailsPage({super.key, 
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
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Target Date: $targetDate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(imageBytes: bytes),
                  ),
                );
              },
              child: Hero(
                tag: 'imageHero',
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Type: $type',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List imageBytes;

  const FullScreenImage({super.key, required this.imageBytes});

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
            child: Image.memory(
              imageBytes,
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

  const OffensesDetailsPage({super.key, 
    required this.title,
    required this.description,
    required this.targetDate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Target Date: $targetDate',
              style: const TextStyle(fontSize: 16),
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

  const AllDetailsPage({super.key, 
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
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Target Date: $targetDate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (bytes != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageBytes: bytes!),
                    ),
                  );
                },
                child: SizedBox(
                  height: 200,
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
    );
  }
}
