import 'package:equatable/equatable.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class LoadSurvey extends SurveyEvent {}

class LoadWarga extends SurveyEvent {}

class LoadHistory extends SurveyEvent {}
