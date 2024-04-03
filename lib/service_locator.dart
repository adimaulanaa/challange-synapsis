import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:synapsis/framework/managers/realm_config/realm_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/features/auth/data/datasources/index.dart';
import 'package:synapsis/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:synapsis/features/auth/domain/repositories/auth_repository.dart';
import 'package:synapsis/features/auth/domain/usecases/index.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synapsis/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:synapsis/features/survey/data/datasources/survey_remote_datasource.dart';
import 'package:synapsis/features/survey/data/repositories/survey_repository_impl.dart';
import 'package:synapsis/features/survey/domain/repositories/survey_repository.dart';
import 'package:synapsis/features/survey/presentation/bloc/survey_bloc.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_bloc.dart';
import 'package:synapsis/framework/blocs/messaging/index.dart';
import 'package:synapsis/framework/managers/hive_db_helper.dart';
import 'package:synapsis/framework/managers/http_manager.dart';
import 'package:synapsis/framework/network/network_info.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> initDependencyInjection() async {
  // ************************************************ //
  // !featuress - Auth
  serviceLocator.registerFactory<AuthBloc>(() => AuthBloc(
        checkSignIn: serviceLocator(),
        signOut: serviceLocator(),
        prefs: serviceLocator(),
        persistToken: serviceLocator(),
      ));

  // Login Bloc
  serviceLocator.registerFactory<LoginBloc>(() => LoginBloc(
        prefs: serviceLocator(),
        signIn: serviceLocator(),
        dbServices: serviceLocator(),
      ));
  // Messaging Bloc
  serviceLocator.registerFactory<MessagingBloc>(
    () => MessagingBloc(),
  );

  // Use Cases
  serviceLocator.registerLazySingleton(
    () => CheckSigninUseCase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => PersistTokenUseCase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => SigninUseCase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => SignOutUseCase(
      serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
      ));

  // Data Sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      httpManager: serviceLocator(),
      dbService: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
      dbService: serviceLocator(),
      realmDbService: serviceLocator(),
    ),
  );

  // ************************************************ //
  //! Features - Dashboard
  // Bloc
  // Dashboard Bloc
  serviceLocator.registerFactory<SurveyBloc>(() => SurveyBloc(
        survey: serviceLocator(),
      ));

  // Use Cases
  // serviceLocator
  //     .registerLazySingleton(() => DashboardUseCase(serviceLocator()));
  // serviceLocator
  //     .registerLazySingleton(() => DashboardFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<SurveyRepository>(() => SurveyRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<SurveyRemoteDataSource>(
      () => SurveyRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<SurveyLocalDataSource>(
      () => SurveyLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
            realmDbService: serviceLocator(),
          ));

  // ************************************************ //

  // !Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => InternetConnectionChecker(),
  );

  // !Managers
  final sharedPreferences = await SharedPreferences.getInstance();
  //
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  serviceLocator.registerSingleton<HiveDbServices>(
    HiveDbServices(),
  );
  serviceLocator.registerSingleton<RealmDBServices>(
    RealmDBServices(),
  );
  serviceLocator.registerLazySingleton<HttpManager>(
    () => AppHttpManager(),
  );
}
