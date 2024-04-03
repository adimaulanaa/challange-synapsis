import 'package:equatable/equatable.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoaded extends LoginState {
  const LoginLoaded({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [
        username,
        password,
      ];
}

class LoginSubmitting extends LoginState {}

class LoginSuccess extends LoginState {
  const LoginSuccess({
    required this.success,
  });

  final UserModel success;

  @override
  List<Object> get props => [
        success,
      ];
}

class LoginFailure extends LoginState {
  const LoginFailure({
    required this.error,
    required this.message,
  });

  final String error;
  final String message;

  @override
  List<Object> get props => [
        error,
        message,
      ];

  @override
  String toString() => 'Login Failure { error: $error }';
}
