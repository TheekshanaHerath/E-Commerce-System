part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class SignUpInProgressState extends AuthState {}

class SignUpSuccessState extends AuthState {}

class SignUpErrorState extends AuthState {
  final String error;

  SignUpErrorState({required this.error});
}