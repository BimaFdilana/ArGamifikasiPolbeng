import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../auth/data/model/user_model.dart';


class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<User> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/profile');

      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal memuat profil: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
