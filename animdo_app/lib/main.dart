import 'package:animdo_app/pages/homePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(animdo());
}

class animdo extends StatelessWidget {
  const animdo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animdo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: homePage(
      ),
    );
  }
}