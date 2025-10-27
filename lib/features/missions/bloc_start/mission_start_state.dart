part of 'mission_start_bloc.dart';

@freezed
class MissionStartState with _$MissionStartState {
  const factory MissionStartState.initial() = _Initial;
  const factory MissionStartState.loading() = _Loading;
  const factory MissionStartState.success({
    required String message,
  }) = _Success;
  const factory MissionStartState.error({
    required String message,
  }) = _Error;
}
