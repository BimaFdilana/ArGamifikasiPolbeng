part of 'mission_detail_bloc.dart';

@freezed
class MissionDetailState with _$MissionDetailState {
  const factory MissionDetailState.initial() = _Initial;
  const factory MissionDetailState.loading() = _Loading;
  // State sukses, membawa satu objek Mission
  const factory MissionDetailState.loaded({
    required Mission mission,
  }) = _Loaded;
  const factory MissionDetailState.error({
    required String message,
  }) = _Error;
}
