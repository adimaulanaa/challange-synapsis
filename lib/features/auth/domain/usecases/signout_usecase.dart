import 'package:dartz/dartz.dart';
import 'package:synapsis/features/auth/domain/repositories/auth_repository.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/core/usecase/usecase.dart';

class SignOutUseCase implements UseCase<bool, NoParams> {
  SignOutUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) => repository.signOut();
}
