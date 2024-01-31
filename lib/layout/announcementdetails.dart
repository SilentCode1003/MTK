import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class AnnouncementDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String targetDate;
  final String image;
  final String type;

  AnnouncementDetailsPage({
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
        title: Text('Announcement Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Target Date: $targetDate',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              child: Image.memory(
                bytes,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Type: $type',
              style: TextStyle(fontSize: 16),
            ),
          ],
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

  OffensesDetailsPage({
    required this.title,
    required this.description,
    required this.targetDate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Target Date: $targetDate',
              style: TextStyle(fontSize: 16),
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
  final String? image; // Make image nullable
  final String? type;

  AllDetailsPage({
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
        title: Text('Announcement Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Target Date: $targetDate',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            if (bytes != null) // Check if bytes are available
              Container(
                height: 200,
                width: double.infinity,
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
