part of 'mission_bloc.dart';

@freezed
class MissionEvent with _$MissionEvent {
  const factory MissionEvent.missionsFetched() = _MissionsFetched;
}