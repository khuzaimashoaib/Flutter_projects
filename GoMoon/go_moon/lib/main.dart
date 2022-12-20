import 'package:flutter/material.dart';
import 'package:go_moon/pages/home_page.dart';

void main() {
  runApp(const MoonApp());
}
class MoonApp extends StatelessWidget {
  const MoonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GoMoon",
      theme: ThemeData(scaffoldBackgroundColor: Color.fromRGBO(31, 31, 31, 1.0),),
      debugShowCheckedModeBanner: false,
      home:HomePage(),
    );
  }
}

