part of 'mission_completion_bloc.dart';

@freezed
class MissionCompletionEvent with _$MissionCompletionEvent {
  const factory MissionCompletionEvent.completed({
    required int missionId,
  }) = _Completed;
}
