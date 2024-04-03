import 'package:equatable/equatable.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class ShowLogin extends AuthEvent {}

class LoggedIn extends AuthEvent {
  const LoggedIn({
    required this.loggedInData,
  });

  final UserModel loggedInData;

  @override
  List<Object> get props => [loggedInData];

  @override
  String toString() => 'LoggedIn { loggedInData: $loggedInData }';
}

class LoggedOut extends AuthEvent {}
