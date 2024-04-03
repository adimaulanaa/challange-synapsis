import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';
import 'package:synapsis/features/auth/domain/repositories/auth_repository.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/core/usecase/usecase.dart';

class PersistTokenUseCase implements UseCase<bool, TokenParams> {
  PersistTokenUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(TokenParams params) =>
      repository.persistToken(params.userData);
}

class TokenParams extends Equatable {
  const TokenParams({
    required this.userData,
  });

  final UserModel userData;

  @override
  List<Object> get props => [userData];
}
