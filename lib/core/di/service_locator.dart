import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../api/api_client.dart';
import '../storage/local_storage.dart';
import 'package:polbeng_ar_gamifikasi_polbeng_mobile/features/missions/bloc/mission_bloc.dart';
import 'package:polbeng_ar_gamifikasi_polbeng_mobile/features/missions/data/repository/mission_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/data/repository/profile_repository.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // External
  final sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Core
  sl.registerLazySingleton(() => LocalStorage(sl()));
  sl.registerLazySingleton(() => ApiClient(sl(), sl()));

  // Repositories
  sl.registerLazySingleton(() => AuthRepository(sl()));
  sl.registerLazySingleton(() => MissionRepository(sl()));
  sl.registerLazySingleton(() => ProfileRepository(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(sl(), sl(), sl()));
  sl.registerFactory(() => MissionBloc(sl()));
  sl.registerFactory(() => ProfileBloc(sl()));
}
