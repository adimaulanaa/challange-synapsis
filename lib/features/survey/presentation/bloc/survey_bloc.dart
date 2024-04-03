import 'package:bloc/bloc.dart';
import 'package:synapsis/features/survey/domain/repositories/survey_repository.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_event.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_state.dart';
import 'package:synapsis/framework/managers/helper.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc({
    required SurveyRepository survey,
  })  : _survey = survey,
        super(SurveyInitial()) {
    on<LoadSurvey>(onLoadSurvey);
    on<LoadSurveyId>(onLoadSurveyId);
  }

  final SurveyRepository _survey;

  void onLoadSurvey(LoadSurvey event, Emitter<SurveyState> emit) async {
    emit(SurveyLoading());

    final failureOrSuccessOnline = await _survey.survey();
    emit(
      failureOrSuccessOnline.fold(
        (failure) => SurveyFailure(error: mapFailureToMessage(failure)),
        (success) => SurveyLoaded(data: success),
      ),
    );
  }

  void onLoadSurveyId(LoadSurveyId event, Emitter<SurveyState> emit) async {
    emit(SurveyIdLoading());

    final failureOrSuccessOnline = await _survey.surveyId(event.id);
    emit(
      failureOrSuccessOnline.fold(
        (failure) => SurveyIdFailure(error: mapFailureToMessage(failure)),
        (success) => SurveyIdLoaded(data: success),
      ),
    );
  }
}
