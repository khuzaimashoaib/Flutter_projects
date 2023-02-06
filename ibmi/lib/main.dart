import 'package:flutter/cupertino.dart';
import 'package:ibmi/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'IBMI',
      initialRoute: '/',
      routes: {
        '/':(context) => const MainPage(),
          
        
      },
    );
  }
}
