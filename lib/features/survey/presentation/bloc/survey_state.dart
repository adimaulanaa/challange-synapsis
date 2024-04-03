import 'package:synapsis/features/survey/data/models/survey_model.dart';
import 'package:synapsis/utils/model.dart';

abstract class SurveyState {
  List<Object> get props => [];
}

class SurveyInitial extends SurveyState {}

class SurveyLoading extends SurveyState {}

class WargaLoading extends SurveyState {}

class SurveyLoaded extends SurveyState {
  SurveyLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  SurveyModel? data;

  @override
  List<Object> get props => [
        isFromCacheFirst,
        data!,
      ];
}

class WargaLoaded extends SurveyState {
  WargaLoaded({
    this.total,
  });

  DashModel? total;

  @override
  List<Object> get props => [
        total!,
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

class WargaFailure extends SurveyState {
  WargaFailure({
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
