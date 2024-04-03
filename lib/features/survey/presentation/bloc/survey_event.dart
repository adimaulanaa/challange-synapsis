import 'package:equatable/equatable.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class LoadSurvey extends SurveyEvent {}

class LoadSurveyId extends SurveyEvent {
  final String id;

  const LoadSurveyId({
    required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];
}
