import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';
import 'package:synapsis/features/auth/domain/repositories/auth_repository.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/core/usecase/usecase.dart';

class SigninUseCase implements UseCase<UserModel, SignInParams> {
  SigninUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserModel>> call(SignInParams params) async {
    return await repository.signInWithCredentials(
        params.username, params.password);
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => [
        username,
        password,
      ];
}
