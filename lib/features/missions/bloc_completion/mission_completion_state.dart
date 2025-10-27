part of 'mission_completion_bloc.dart';

@freezed
class MissionCompletionState with _$MissionCompletionState {
  const factory MissionCompletionState.initial() = _Initial;
  const factory MissionCompletionState.loading() = _Loading;
  const factory MissionCompletionState.success({
    required String message,
    required int totalPoints,
  }) = _Success;
  const factory MissionCompletionState.error({
    required String message,
  }) = _Error;
}
