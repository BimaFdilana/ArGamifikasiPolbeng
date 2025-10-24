import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../model/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  AuthRepository(this._apiClient);
  Future<AuthResponse> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(
          e.response?.data['message'] ??
              'Email atau password salah',
        );
      }
      throw Exception(
        'Terjadi kesalahan jaringan. Coba lagi nanti.',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    String? newAccessToken;
    try {
      final registerResponse = await _apiClient.dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      newAccessToken =
          registerResponse.data['access_token'];
      if (newAccessToken == null) {
        throw Exception(
          'Gagal mendapatkan token setelah register',
        );
      }

      final profileResponse = await _apiClient.dio.get(
        '/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $newAccessToken',
          },
        ),
      );

      final user = User.fromJson(profileResponse.data);

      return AuthResponse(
        accessToken: newAccessToken,
        user: user,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
       final responseData = e.response?.data;
       if (responseData != null && responseData is Map) {
        if (responseData.containsKey('email') && responseData['email'] is List && responseData['email'].isNotEmpty) {
          throw Exception(responseData['email'][0].toString());
        }
        if (responseData.containsKey('password') && responseData['password'] is List && responseData['password'].isNotEmpty) {
          throw Exception(responseData['password'][0].toString());
        }
       }
       throw Exception('Data registerasi tidak valid');
      }

      if(e.requestOptions.path == '/profile') {
        throw Exception('Gagal mendapatkan data profile');
      }
      throw Exception(
        'Terjadi kesalahan jaringan. Coba lagi nanti.',
      );
    } catch (e) {
      throw Exception(
        'Terjadi kesalahan new: ${e.toString()}',
      );
    }
  }
}
