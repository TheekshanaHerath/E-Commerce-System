import '../error/app_exception.dart';

sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class FailureResult<T> extends Result<T> {
  final Failure failure;
  FailureResult(this.failure);
}