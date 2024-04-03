// ignore_for_file: unnecessary_null_comparison, prefer_is_empty

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:synapsis/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_bloc.dart';
import 'package:synapsis/framework/managers/realm_config/realm_db_helper.dart';
import 'package:synapsis/service_locator.dart';
import 'package:synapsis/config/global_vars.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/framework/managers/hive_db_helper.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:synapsis/framework/widgets/loading_indicator.dart';
import 'package:synapsis/framework/blocs/messaging/messaging_bloc.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synapsis/framework/blocs/messaging/messaging_event.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_event.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_state.dart';
import 'package:synapsis/features/login/presentation/pages/login_page.dart';
import 'package:synapsis/features/survey/presentation/survey_page.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:synapsis/features/login/presentation/pages/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.openBox(HiveDbServices.boxLoggedInUser);
  // !Force potrait mode
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  HttpOverrides.global = MyHttpOverrides();

  // !Check apakah aplikasi baru di install/reinstall
  final prefs = await SharedPreferences.getInstance();
  GlobalConfiguration().loadFromAsset("app_settings");
  await dotenv.load(fileName: ".env");

  //  !Load static environment wrapper
  Env();
  if (prefs.getBool('first_run') ?? true) {
    await Hive.deleteFromDisk();
    final realm = RealmDBServices(); // @delete realm db
    await realm.deleteAll();
    printWarning("=====Aplikasi baru di install hapus local storage=====");
    prefs.setBool('first_run', false);
  }
  await initDependencyInjection();

  if (Env().value.isInDebugMode) {
    printWarning('app: ${Env().value.appName}');
    printWarning('API Base Url: ${Env().value.apiBaseUrl}');
  }

  try {
    await DotEnv().load(fileName: '.env');
    // load static environment wrapper
    Env();
  } catch (e, trace) {
    if (Env().isInDebugMode) {
      printWarning('[CONFIG] $e & $trace');
    }
  }

  Bloc.observer = SimpleBlocObserver(); // ERROR

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => serviceLocator.get<AuthBloc>()
            ..add(
              AppStarted(),
            ),
        ),
        BlocProvider<MessagingBloc>(
          create: (BuildContext context) => serviceLocator.get<MessagingBloc>()
            ..add(
              MessagingStarted(),
            ),
        ),
        BlocProvider<LoginBloc>(
            create: (BuildContext context) => serviceLocator.get<LoginBloc>()),
        BlocProvider<SurveyBloc>(
            create: (BuildContext context) =>
                serviceLocator.get<SurveyBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> loadFromGlobalConfig(GlobalConfiguration result) async {
  if (result != null) {
    // add addition DNS Checking from remote config
    initDataConnectionChecker();
  }

  return;
}

void initDataConnectionChecker({bool isDefault = false}) {
  final appConfig = GlobalConfiguration().appConfig;

  // LOAD CONNECTION CHECKER PRIMARY DNS
  if (appConfig.containsKey(GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED)) {
    final bool isCheckerEnabled =
        appConfig[GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED];

    if (isCheckerEnabled) {
      final String jsonHosts =
          appConfig[GlobalVars.CONFIG_CONNECTION_CHECKER_IP_ADDRESSES];

      if (jsonHosts != null && jsonHosts.isNotEmpty) {
        List hosts = jsonDecode(jsonHosts);

        if (hosts.length > 0) {
          List<AddressCheckOptions> addresses = hosts
              .map(
                (json) => AddressCheckOptions(
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<InternetConnectionStatus> _connection =
      InternetConnectionChecker().onStatusChange.listen((event) {});

  @override
  void initState() {
    super.initState();

    bool isConnected = false;
    _connection =
        serviceLocator<NetworkInfo>().onInternetStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected = true;
          break;
        case InternetConnectionStatus.disconnected:
          isConnected = false;
          break;
      }

      BlocProvider.of<MessagingBloc>(context).add(
        InternetConnectionChanged(
          connected: isConnected,
        ),
      );
    });
  }

  @override
  void dispose() {
    _connection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (Env().value.isInDebugMode) {
                  printWarning('state $state');
                }
                if (state is ViewOnBoarding) {
                  return OnBoardingScreen();
                } else if (state is ViewLogin) {
                  return const LoginPage();
                } else if (state is AuthenticationAuthenticated) {
                  return const SurveyPage();
                } else if (state is AuthenticationUnauthenticated) {
                  return OnBoardingScreen();
                  // return const LoginPage();
                } else if (state is AuthenticationLoading) {
                  return const Center(
                    child: LoadingPage(),
                  );
                }
                return const Center(
                  child: LoadingPage(),
                );
              },
            ),
        SurveyPage.routeName: (context) => const SurveyPage(),
      },
    );
  }
}

class AuthStateNotifier extends ChangeNotifier {
  late final StreamSubscription _blocStream;

  authStateProvider(AuthBloc bloc) {
    _blocStream = bloc.stream.listen((event) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _blocStream.cancel();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (Env().isInDebugMode) {
      printWarning('event: $event');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (Env().isInDebugMode) {
      printWarning('nextState: ${transition.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (Env().isInDebugMode) {
      printError(error);
    }
    super.onError(bloc, error, stackTrace);
  }
}
