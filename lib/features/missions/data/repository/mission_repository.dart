import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../model/mission_model.dart';

class MissionRepository {
  final ApiClient _apiClient;

  MissionRepository(this._apiClient);

  Future<List<Mission>> getMissions() async {
    try {
      final response = await _apiClient.dio.get(
        '/missions',
      );

      List<dynamic> list = response.data;

      return list.map((m) => Mission.fromJson(m)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal memuat misi: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
