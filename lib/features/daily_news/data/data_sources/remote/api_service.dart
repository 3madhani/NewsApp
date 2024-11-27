import 'package:dio/dio.dart';

class ApiService {
  final _apiKey = "a537459961074f13be638a79146f71c2";
  final _baseUrl = "https://newsapi.org/v2/";
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> get(
      {required String endPoint, Map<String, String>? queryParams}) async {
    // Add API key to the query parameters
    final params = {
      'apiKey': _apiKey,
      if (queryParams != null) ...queryParams,
    };
    try {
      final response =
          await _dio.get("$_baseUrl$endPoint", queryParameters: params);
      print(response.data);
      return response.data;
    } catch (e) {
      throw DioException(
          requestOptions: RequestOptions(
              path: "$_baseUrl$endPoint", queryParameters: params));
    }
  }
}
