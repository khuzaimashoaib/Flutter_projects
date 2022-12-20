import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class gamePageProvider extends ChangeNotifier {
  final Dio dio = Dio();

  BuildContext context;
  gamePageProvider({required this.context}){
    dio.options.baseUrl = "https://opentdb.com/api.php";
    print('hello');
  }
}