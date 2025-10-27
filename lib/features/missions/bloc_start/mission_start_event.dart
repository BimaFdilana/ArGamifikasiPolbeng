part of 'mission_start_bloc.dart';

@freezed
class MissionStartEvent with _$MissionStartEvent {
  const factory MissionStartEvent.started({
    required int missionId,
  }) = _Started;
}
