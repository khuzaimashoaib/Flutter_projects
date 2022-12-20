import 'package:flutter/material.dart';
import 'package:taskly/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'package:hive/hive.dart';
void main() async {
  await Hive.initFlutter("hive_boxes");
  runApp(taskly());
}

class taskly extends StatelessWidget {
  const taskly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}