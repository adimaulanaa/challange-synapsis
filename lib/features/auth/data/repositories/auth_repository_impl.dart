import 'package:dartz/dartz.dart';
import 'package:synapsis/config/string_resource.dart';
import 'package:synapsis/env.dart';
import 'package:synapsis/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:synapsis/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';
import 'package:synapsis/features/auth/domain/repositories/auth_repository.dart';
import 'package:synapsis/framework/core/exceptions/app_exceptions.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, UserModel>> signInWithCredentials(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user =
            await remoteDataSource.signInWithCredentials(email, password);
        await localDataSource.persistToken(user);
        return Right(user);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      return const Left(
          NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    bool isSignin = await localDataSource.isSignedIn();
    return Right(isSignin);
  }

  @override
  Future<Either<Failure, bool>> persistToken(UserModel userData) async {
    await localDataSource.persistToken(userData);
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
      } catch (e) {
        if (Env().value.isInDebugMode) {
          printWarning("[signOut] catching error $e");
        }
      }
    }

    await localDataSource.clearToken();

    return const Right(true);
  }
}
