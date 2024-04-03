import 'package:synapsis/features/survey/data/models/survey_id_model.dart';
import 'package:synapsis/features/survey/data/models/survey_model.dart';

abstract class SurveyState {
  List<Object> get props => [];
}

class SurveyInitial extends SurveyState {}

class SurveyLoading extends SurveyState {}

class SurveyIdLoading extends SurveyState {}

class SurveyLoaded extends SurveyState {
  SurveyLoaded({
    this.data,
  });

  SurveyModel? data;

  @override
  List<Object> get props => [
        data!,
      ];
}

class SurveyIdLoaded extends SurveyState {
  SurveyIdLoaded({
    this.data,
  });

  SurveyIdModel? data;

  @override
  List<Object> get props => [
        data!,
      ];
}

class SurveyFailure extends SurveyState {
  SurveyFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [
        error,
      ];

  @override
  String toString() => 'Survey Failure { error: $error }';
}

class SurveyIdFailure extends SurveyState {
  SurveyIdFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [
        error,
      ];

  @override
  String toString() => 'Survey Failure { error: $error }';
}
