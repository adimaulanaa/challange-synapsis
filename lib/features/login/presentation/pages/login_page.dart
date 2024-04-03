import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_bloc.dart';
import 'package:synapsis/features/login/presentation/pages/login_screen.dart';
import 'package:synapsis/service_locator.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator.get<LoginBloc>(),
      child: Scaffold(
        body: ProgressHUD(child: LoginScreen()),
      ),
    );
  }
}
