import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../auth/data/model/user_model.dart';
import '../data/repository/profile_repository.dart';


part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository)
    : super(const _Initial()) {
    on<_ProfileFetched>((event, emit) async {
      emit(const ProfileState.loading());
      try {
        final user = await _profileRepository.getProfile();
        emit(ProfileState.loaded(user: user));
      } catch (e) {
        emit(ProfileState.error(message: e.toString()));
      }
    });
  }
}
