import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([
    this.message = '',
    this.error = '',
  ]);

  final String message;
  final String error;

  @override
  List<Object> get props => [message, error];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([message]) : super(message ?? '');
}

class NetworkFailure extends Failure {
  const NetworkFailure([message]) : super(message ?? '');
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([message]) : super(message ?? '');
}

class CacheFailure extends Failure {
  const CacheFailure([message]) : super(message ?? '');
}

class InvalidCredentialFailure extends Failure {
  const InvalidCredentialFailure([message]) : super(message ?? '');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([message]) : super(message ?? '');
}

class BadRequestFailure extends Failure {
  const BadRequestFailure([message]) : super(message ?? '');
}

class UnauthorisedFailure extends Failure {
  const UnauthorisedFailure([message]) : super(message ?? '');
}

class FetchDataFailure extends Failure {
  const FetchDataFailure([message]) : super(message ?? '');
}
