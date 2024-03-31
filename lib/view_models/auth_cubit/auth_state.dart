part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  AuthSuccess({
    required this.userData,
    required this.scoreHistory,
  });

  CustomUser userData;
  List<(String, int)> scoreHistory;
}

final class Authed extends AuthState {}

final class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
