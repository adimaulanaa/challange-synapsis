import 'package:dartz/dartz.dart';
import 'package:synapsis/features/auth/domain/repositories/auth_repository.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/core/usecase/usecase.dart';

class CheckSigninUseCase implements UseCase<bool, NoParams> {
  CheckSigninUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      repository.isSignedIn();
}
