import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final String message;
  const LoadingSpinner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 16.0),
          Text(message),
        ],
      ),
    );
  }
}
