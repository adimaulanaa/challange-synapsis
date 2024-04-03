abstract class AuthState {
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthState {}

class ViewOnBoarding extends AuthState {}

class ViewLogin extends AuthState {}

class AuthenticationAuthenticated extends AuthState {}

class AuthenticationUnauthenticated extends AuthState {}

class AuthenticationLoading extends AuthState {}

class AuthenticationError extends AuthState {
  AuthenticationError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

class OfflineSyncSuccess extends AuthState {
  OfflineSyncSuccess({
    required this.data,
  });

  final List<int> data;

  @override
  List<Object> get props => [data];
}

class OfflineSyncFailure extends AuthState {
  OfflineSyncFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'OfflineSyncFailure { error: $error }';
}
