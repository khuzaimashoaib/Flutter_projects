import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class httpService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _base_url;

  httpService(){
    _appConfig =  GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String path) async {
    try {
      String url = "$_base_url$path";
      Response response = await dio.get(url);
      return response;
    } catch(e){
      print('unable to find service');
      print(e);
    }   
  }
}