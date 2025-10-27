import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/repository/mission_repository.dart';

part 'mission_start_event.dart';
part 'mission_start_state.dart';
part 'mission_start_bloc.freezed.dart';

class MissionStartBloc extends Bloc<MissionStartEvent, MissionStartState> {
  final MissionRepository _missionRepository;

  MissionStartBloc(this._missionRepository) : super(const _Initial()) {
    on<_Started>((event, emit) async {
      emit(MissionStartState.loading());
      try {
        final result = await _missionRepository.startMission(event.missionId);
        emit(MissionStartState.success(
          message: result['message'],
        ));
      } catch (e) {
        emit(MissionStartState.error(message: e.toString()));
        emit(MissionStartState.initial());
      }
    });
  }
}
