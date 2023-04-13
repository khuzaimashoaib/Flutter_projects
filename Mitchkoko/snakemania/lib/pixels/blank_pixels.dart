import 'package:flutter/material.dart';

class BlankPixels extends StatelessWidget {
  const BlankPixels({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[900],
        ),
      ),
    );
  }
}
