import 'package:flutter/material.dart';

class FoodPixels extends StatelessWidget {
  const FoodPixels({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.green,
        ),
      ),
    );
  }
}
