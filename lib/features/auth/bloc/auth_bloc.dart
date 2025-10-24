import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/storage/local_storage.dart';
import '../data/model/user_model.dart';
import '../data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final LocalStorage _localStorage;

  AuthBloc(this._authRepository, this._localStorage)
    : super(const _Initial()) {
    on<_LoginRequest>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final authResponse = await _authRepository.login(
          event.email,
          event.password,
        );

        await _localStorage.saveToken(
          authResponse.accessToken,
        );

        emit(
          AuthState.authenticated(user: authResponse.user),
        );
      } catch (e) {
        emit(AuthState.error(message: e.toString()));
        emit(const AuthState.initial());
      }
    });

    on<_RegisterRequest>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final authResponse = await _authRepository.register(
          name: event.name,
          email: event.email,
          password: event.password,
          passwordConfirmation: event.passwordConfirmation,
        );

        await _localStorage.saveToken(
          authResponse.accessToken,
        );

        emit(
          AuthState.authenticated(user: authResponse.user),
        );
      } catch (e) {
        emit(AuthState.error(message: e.toString()));
        emit(const AuthState.initial());
      }
    });

    on<_LogoutRequest>((event, emit) async {
      emit(const AuthState.loading());
      await _localStorage.clearToken();
      emit(const AuthState.unauthenticated());
    });
  }
}
