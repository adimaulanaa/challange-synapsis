import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_bloc.dart';
import 'package:synapsis/features/survey/presentation/survey_screen.dart';
import 'package:synapsis/service_locator.dart';
import 'package:synapsis/utils/colors.dart';

class SurveyPage extends StatelessWidget {
  static const routeName = '/survey';

  const SurveyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator.get<SurveyBloc>(),
            ),
          ],
          child: ProgressHUD(child: const SurveyScreen()),
        ),
      ),
    );
  }
}
