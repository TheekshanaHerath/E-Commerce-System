part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final SignUpRequestModel request;

  SignUpEvent({required this.request});
}