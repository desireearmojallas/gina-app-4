import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pop();
                },
                child: InteractiveViewer(
                  child: Image.network(imageUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
