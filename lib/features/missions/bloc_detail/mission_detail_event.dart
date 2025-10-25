part of 'mission_detail_bloc.dart';

@freezed
class MissionDetailEvent with _$MissionDetailEvent {
  const factory MissionDetailEvent.fetched({
    required int missionId,
  }) = _Fetched;
}
