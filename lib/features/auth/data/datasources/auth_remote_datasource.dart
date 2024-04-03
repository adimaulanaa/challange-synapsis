import 'dart:io';
import 'package:synapsis/env.dart';
import 'package:synapsis/config/global_vars.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/managers/http_manager.dart';
import 'package:synapsis/framework/managers/hive_db_helper.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';
import 'package:synapsis/framework/core/exceptions/app_exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithCredentials(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbService,
  });

  final HttpManager httpManager;
  final HiveDbServices dbService;

  @override
  Future<UserModel> signInWithCredentials(
      String username, String password) async {
    String apiLogin = "/login";

    return _signInWithCredentials(
        apiLogin, {"nik": username, "password": password});
  }

  Future<UserModel> _signInWithCredentials(
      String url, Map<String, dynamic> body) async {
    final response = await httpManager.post(
      url: url,
      body: body,
    );

    if (response != null && response.statusCode == 200) {
      UserModel result = UserModel.fromJson(response.data);
      return result;
    } else {
      throw ServerException();
    }
  }

  // ignore: unused_element
  String _getAuthUrl(String username) {
    String path =
        "${GlobalConfiguration().getValue(GlobalVars.API_AUTH_URL)}${GlobalConfiguration().getValue(GlobalVars.API_AUTH_PATH)}/$username";
    path +=
        "?application=${GlobalConfiguration().getValue(GlobalVars.APP_NAME)}";

    if (Env().isInDebugMode) {
      // path += '&env=' + GlobalConfiguration().getValue(GlobalVars.ENV);
      printWarning('[_getAuthUrl] $path');
    }
    return path;
  }

  @override
  Future<void> signOut() => _signOut('/logout');

  Future<void> _signOut(url) async {
    var token = await dbService.getData(HiveDbServices.boxToken);
    await httpManager.post(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
  }
}
