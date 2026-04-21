import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api/network_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final response = await repository.login(
          event.email,
          event.password,
        );

        emit(LoginSuccess(
          message: response.message,
          data: response.data,
        ));
      } on NetworkException catch (e) {
        emit(LoginFailure(message: e.message));
      } catch (e) {
        emit(LoginFailure(message: "Unexpected error: $e"));
      }
    });
  }
}