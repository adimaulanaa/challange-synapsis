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
    on<LoadWarga>(onLoadWarga);
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

  void onLoadWarga(LoadWarga event, Emitter<SurveyState> emit) async {
    emit(WargaLoading());

    final failureOrSuccessOnline = await _survey.survey();
    emit(
      failureOrSuccessOnline.fold(
        (failure) => WargaFailure(error: mapFailureToMessage(failure)),
        (success) => SurveyLoaded(data: success),
      ),
    );
  }
}
