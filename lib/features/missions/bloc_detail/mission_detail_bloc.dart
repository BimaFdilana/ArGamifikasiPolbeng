import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/model/mission_model.dart';
import '../data/repository/mission_repository.dart';

part 'mission_detail_event.dart';
part 'mission_detail_state.dart';
part 'mission_detail_bloc.freezed.dart';

class MissionDetailBloc
    extends Bloc<MissionDetailEvent, MissionDetailState> {
  final MissionRepository _missionRepository;

  MissionDetailBloc(this._missionRepository)
    : super(const _Initial()) {
    on<_Fetched>((event, emit) async {
      emit(const MissionDetailState.loading());
      try {
        final mission = await _missionRepository
            .getMissionDetail(event.missionId);
        emit(MissionDetailState.loaded(mission: mission));
      } catch (e) {
        emit(
          MissionDetailState.error(message: e.toString()),
        );
      }
    });
  }
}
