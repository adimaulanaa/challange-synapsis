import 'package:dartz/dartz.dart';
import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/features/survey/domain/repositories/survey_repository.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/core/usecase/usecase.dart';

class SurveyUseCase implements UseCase<SurveyModel, NoParams> {
  SurveyUseCase(this.repository);

  final SurveyRepository repository;

  @override
  Future<Either<Failure, SurveyModel>> call(NoParams params) =>
      repository.survey();
}
