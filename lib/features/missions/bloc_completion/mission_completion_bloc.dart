import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/repository/mission_repository.dart';

part 'mission_completion_event.dart';
part 'mission_completion_state.dart';
part 'mission_completion_bloc.freezed.dart';

class MissionCompletionBloc extends Bloc<MissionCompletionEvent, MissionCompletionState> {
  final MissionRepository _missionRepository;

  MissionCompletionBloc(this._missionRepository) : super(const _Initial()) {
    on<_Completed>((event, emit) async {
      emit(MissionCompletionState.loading());
      try {
        final result = await _missionRepository.completeMission(event.missionId);
        emit(MissionCompletionState.success(
          message: result['message'],
          totalPoints: result['total_points'],
        ));
      } catch (e) {
        emit(MissionCompletionState.error(message: e.toString()));
        emit(MissionCompletionState.initial());
      }
    });
  }
}
