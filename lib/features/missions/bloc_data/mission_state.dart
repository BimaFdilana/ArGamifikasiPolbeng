part of 'mission_bloc.dart';

@freezed
class MissionState with _$MissionState {
  const factory MissionState.initial() = _Initial;
  const factory MissionState.loading() = _Loading;
  const factory MissionState.loaded({
    required List<Mission> missions,
  }) = _Loaded;
  const factory MissionState.error({
    required String message,
  }) = _Error;
}
