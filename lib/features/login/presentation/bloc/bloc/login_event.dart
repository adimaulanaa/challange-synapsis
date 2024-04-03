import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoadLogin extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginWithCredentialsPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [
        username,
        password,
      ];

  @override
  String toString() =>
      'Login With Credentials Pressed { username: $username, password: $password }';
}
