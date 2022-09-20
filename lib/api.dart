import 'package:dio/dio.dart';

class API {
  Dio dio = Dio();

  Future<Map<String, dynamic>> getData(String searchedMedicine) async {
    Response response = await dio
        .get('https://api.fda.gov/drug/label.json?search=$searchedMedicine');
    return response.data;
  }
}
