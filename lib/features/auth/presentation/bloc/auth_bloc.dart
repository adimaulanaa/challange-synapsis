import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/config/global_vars.dart';
import 'package:synapsis/env.dart';
import 'package:synapsis/features/auth/domain/usecases/check_signin_usecase.dart';
import 'package:synapsis/features/auth/domain/usecases/persist_token_usecase.dart';
import 'package:synapsis/features/auth/domain/usecases/signout_usecase.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_event.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_state.dart';
import 'package:synapsis/framework/core/usecase/usecase.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/network/network_info.dart';
import 'package:synapsis/service_locator.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with ChangeNotifier {
  AuthBloc({
    required CheckSigninUseCase checkSignIn,
    required PersistTokenUseCase persistToken,
    required SignOutUseCase signOut,
    required SharedPreferences prefs,
  })  : _checkSignIn = checkSignIn,
        _persistToken = persistToken,
        _signOut = signOut,
        super(AuthenticationUninitialized()) {
    on<AppStarted>(_onAppStared);
    on<ShowLogin>(_onShowLogin);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  final CheckSigninUseCase _checkSignIn;
  final SignOutUseCase _signOut;
  final PersistTokenUseCase _persistToken;
  bool _seen = false;
  late StreamSubscription _userSubscription;

  Future<void> _onAppStared(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    void initDataConnectionChecker({bool isDefault = false}) {
      final appConfig = GlobalConfiguration().appConfig;

      // LOAD CONNECTION CHECKER PRIMARY DNS
      if (appConfig.containsKey(GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED)) {
        final bool isCheckerEnabled =
            appConfig[GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED];

        if (isCheckerEnabled) {
          final String jsonHosts =
              appConfig[GlobalVars.CONFIG_CONNECTION_CHECKER_IP_ADDRESSES];

          if (jsonHosts.isNotEmpty) {
            List hosts = jsonDecode(jsonHosts);

            if (hosts.isNotEmpty) {
              List<AddressCheckOptions> addresses = hosts
                  .map(
                    // ignore: unnecessary_new
                    (json) => new AddressCheckOptions(
                      InternetAddress(json["host"]),
                      port: json["port"],
                      timeout: Duration(seconds: json["timeout_secs"]),
                    ),
                  )
                  .toList();

              if (isDefault) {
                // initialized
                serviceLocator<NetworkInfo>();
              } else {
                serviceLocator<NetworkInfo>().addGlobalDns(addresses);
              }
            }
          }
        }
      }
    }

    //! Load ENV
    initDataConnectionChecker(isDefault: true);
    try {
      await DotEnv().load(fileName: '.env');

      // load static environment wrapper
      Env();
      // add addition DNS Checking from remote config
    } catch (e, trace) {
      if (Env().isInDebugMode) {
        printWarning('$e & $trace');
      }
    }
    var _prefs = serviceLocator<SharedPreferences>();
    _seen = (_prefs.getBool('seen') ?? false);
    final newSessionOrExisting = await _checkSignIn(NoParams());
    emit(newSessionOrExisting.fold(
      (newSession) =>
          _seen ? AuthenticationUnauthenticated() : ViewOnBoarding(),
      (existing) => existing
          ? AuthenticationAuthenticated()
          : _seen
              ? AuthenticationUnauthenticated()
              : ViewOnBoarding(),
    ));
  }

  void _onShowLogin(
    ShowLogin event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthenticationLoading());
    emit(ViewLogin());
  }

  Future<void> _onLoggedIn(
    LoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthenticationLoading());
    await _persistToken(TokenParams(userData: event.loggedInData));
    emit(AuthenticationAuthenticated());
  }

  Future<void> _onLoggedOut(
    LoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthenticationLoading());
    await _signOut(NoParams());
    emit(AuthenticationUnauthenticated());
  }
}
