import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../model/signUp_request_model.dart';
import '../domain/entities/user.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../../../../core/result/result.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;

  AuthBloc(this.signUpUseCase) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUpEvent);
  }

  FutureOr<void> _onSignUpEvent(
      SignUpEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(SignUpInProgressState());

    final user = User(
      name: event.request.name,
      email: event.request.email,
    );

    final result = await signUpUseCase(user);

    // ✅ HANDLE RESULT PROPERLY
    if (result is Success<User>) {
      emit(SignUpSuccessState());
    }

    if (result is FailureResult<User>) {
      emit(SignUpErrorState(
        error: result.failure.message,
      ));
    }
  }
}