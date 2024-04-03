import 'package:dartz/dartz.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithCredentials(
      String username, String password);
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, bool>> persistToken(UserModel userData);
  Future<Either<Failure, bool>> signOut();
}
