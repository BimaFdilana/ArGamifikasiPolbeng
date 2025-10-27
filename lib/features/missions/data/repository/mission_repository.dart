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

  Future<Mission> getMissionDetail(int missionId) async {
    try {
      final response = await _apiClient.dio.get(
        '/missions/$missionId',
      );
      return Mission.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        'Gagal memuat detail misi: ${e.message}',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> startMission(
    int missionId,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/missions/$missionId/start',
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception(
          e.response?.data['message'] ??
              'Misi sudah pernah diselesaikan.',
        );
      }
      throw Exception('Gagal memulai misi: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> completeMission(
    int missionId,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/missions/$missionId/complete',
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception(
          e.response?.data['message'] ??
              'Misi sudah pernah diselesaikan.',
        );
      }
      throw Exception(
        'Gagal menyelesaikan misi: ${e.message}',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
