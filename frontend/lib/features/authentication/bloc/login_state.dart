import 'package:equatable/equatable.dart';
import '../../../data/models/auth_model.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final LoginData data;

  LoginSuccess({
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [message, data];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}