import 'package:dio/dio.dart';

class APIClient {
  final Dio _dio = Dio();

  APIClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer TOKEN HERE';
          handler.next(options);
        },
      ),
    );
  }

  Future<Response> login(String email, password) async {
    try {
      final response = await _dio.post(
        'https://reqres.in/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
