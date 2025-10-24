import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class ApiClient {
  final Dio dio;
  final LocalStorage localStorage;

  ApiClient(this.dio, this.localStorage) {
    // Sesuaikan URL ini dengan alamat server Laravel Anda
    dio.options.baseUrl = 'http://192.168.100.150:8000/api';
    dio.options.headers['Accept'] = 'application/json';

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ambil token dari storage
          final token = localStorage.getToken();
          if (token != null) {
            // Tambahkan token ke header untuk request yang butuh auth
            options.headers['Authorization'] =
                'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}
