import 'package:dartz/dartz.dart';
import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';

abstract class SurveyRepository {
  Future<Either<Failure, SurveyModel>> survey();
}
