import 'package:dartz/dartz.dart';
import 'package:synapsis/config/string_resource.dart';
import 'package:synapsis/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:synapsis/features/survey/data/datasources/survey_remote_datasource.dart';
import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/features/survey/domain/repositories/survey_repository.dart';
import 'package:synapsis/framework/network/network_info.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/core/exceptions/app_exceptions.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  SurveyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final SurveyRemoteDataSource remoteDataSource;
  final SurveyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, SurveyModel>> survey() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSurvey();
        await localDataSource.cacheSurvey(remoteData);
        return Right(remoteData);
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
      return await surveyFromCache();
    }
  }

  Future<Either<Failure, SurveyModel>> surveyFromCache() async {
    final localCache = await localDataSource.getLastCacheSurvey();
    return Right(localCache);
  }
}
