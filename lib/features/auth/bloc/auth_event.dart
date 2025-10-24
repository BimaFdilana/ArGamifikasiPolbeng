part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.authCheckRequest() = _AuthCheckRequest;
  
  const factory AuthEvent.loginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  const factory AuthEvent.registerRequest({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) = _RegisterRequest;

  const factory AuthEvent.logoutRequest() = _LogoutRequest;
}