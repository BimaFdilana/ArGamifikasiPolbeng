import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/model/mission_model.dart';
import '../data/repository/mission_repository.dart';

part 'mission_event.dart';
part 'mission_state.dart';
part 'mission_bloc.freezed.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {
  final MissionRepository _missionRepository;

  MissionBloc(this._missionRepository) : super(const _Initial()) {
    on<_MissionsFetched>((event, emit) async {
      emit(MissionState.loading());
      try {
        final missions = await _missionRepository.getMissions();
        emit(MissionState.loaded(missions: missions));
      } catch (e) {
        emit(MissionState.error(message: e.toString()));
      }
    });
  }
}
