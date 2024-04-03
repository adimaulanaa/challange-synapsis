import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/env.dart';
import 'package:synapsis/features/auth/domain/usecases/signin_usecase.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_event.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_state.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/managers/hive_db_helper.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninUseCase _signIn;
  final SharedPreferences _prefs;

  LoginBloc({
    required SigninUseCase signIn,
    required SharedPreferences prefs,
    required HiveDbServices dbServices,
  })  : _signIn = signIn,
        _prefs = prefs,
        super(LoginInitial()) {
    on<LoadLogin>(_onLoadLogin);
    on<LoginWithCredentialsPressed>(_onLoginWithCredentialsPressed);
  }

  void _onLoadLogin(LoadLogin event, Emitter<LoginState> emit) {
    String username = ''; // _prefs.getString(HiveDbServices.boxUsername);
    String password = '';
    if (Env().isInDebugMode) {
      username = Env().demoUsername!;
      password = Env().demoPassword!;

      if (_prefs.containsKey('last_username')) {
        username = _prefs.getString('last_username')!.trim();
        password = password;
      }
    } else {
      if (_prefs.containsKey('last_username')) {
        username = _prefs.getString('last_username')!.trim();
      }
    }
    emit(LoginLoaded(
      username: username,
      password: password,
    ));
  }

  Future<void> _onLoginWithCredentialsPressed(
      LoginWithCredentialsPressed event, Emitter<LoginState> emit) async {
    emit(LoginSubmitting());
    final failureOrSuccess = await _signIn(
      SignInParams(
        username: event.username,
        password: event.password,
      ),
    );
    emit(
      failureOrSuccess.fold(
        (failure) => LoginFailure(
          error: mapFailureToMessage(failure),
          message: failure.message,
        ),
        (logedIn) => LoginSuccess(success: logedIn),
      ),
    );
  }
}
