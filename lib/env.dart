import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';

import 'config/global_vars.dart';

class Env {
  late Env value;
  String? envName;
  String? appId;
  String? appName;
  String? appTitle;
  String? appVersion;
  String? apiBaseUrl;
  String? apiAuthUrl;
  String? apiConfigUrl;
  String? apiConfigPath;
  String? apiAuthPath;
  String? apiLoginPath;
  String? configSource;
  String? configVersion;
  String? demoUsername;
  String? demoPassword;
  int? configTimestamp;
  int? configHttpTimeout;
  int? configHttpUploadTimeout;
  int? configImageCompressQuality;
  String? errMessageNoRouteMatched;

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  Env() {
    var mapConfig = dotenv.env;
    loadConfig(mapConfig);
    value = this;
  }

  loadConfig(Map<String, dynamic> config) async {
    envName = config[GlobalVars.ENV] ??
        GlobalConfiguration().getValue(GlobalVars.ENV);
    appId = config[GlobalVars.APP_ID] ??
        GlobalConfiguration().getValue(GlobalVars.APP_ID);
    appName = config[GlobalVars.APP_NAME] ??
        GlobalConfiguration().getValue(GlobalVars.APP_NAME);
    apiConfigUrl = config[GlobalVars.API_CONFIG_URL] ??
        GlobalConfiguration().getValue(GlobalVars.API_CONFIG_URL);
    apiConfigPath = config[GlobalVars.API_CONFIG_PATH] ??
        GlobalConfiguration().getValue(GlobalVars.API_CONFIG_PATH);

    // demo user
    demoUsername = config[GlobalVars.DEMO_USERNAME] ??
        GlobalConfiguration().getValue(GlobalVars.DEMO_USERNAME);
    demoPassword = config[GlobalVars.DEMO_PASSWORD] ??
        GlobalConfiguration().getValue(GlobalVars.DEMO_PASSWORD);

    appTitle = GlobalConfiguration().getValue(GlobalVars.APP_TITLE);
    appVersion = GlobalConfiguration().getValue(GlobalVars.APP_VERSION);
    apiBaseUrl = GlobalConfiguration().getValue(GlobalVars.API_BASE_URL);
    apiAuthUrl = GlobalConfiguration().getValue(GlobalVars.API_AUTH_URL);
    apiAuthPath = GlobalConfiguration().getValue(GlobalVars.API_AUTH_PATH);
    apiLoginPath = GlobalConfiguration().getValue(GlobalVars.API_LOGIN_PATH);
    configVersion = GlobalConfiguration().getValue(GlobalVars.CONFIG_VERSION);
    configTimestamp =
        GlobalConfiguration().getValue(GlobalVars.CONFIG_TIMESTAMP);

    configHttpTimeout =
        GlobalConfiguration().getValue(GlobalVars.CONFIG_HTTP_TIMEOUT);
    configHttpUploadTimeout = GlobalConfiguration()
        .getValue(GlobalVars.CONFIG_HTTP_UPLOAD_IMAGE_TIMEOUT);
    configImageCompressQuality = GlobalConfiguration()
        .getValue(GlobalVars.CONFIG_IMAGE_COMPRESS_QUALITY);

    errMessageNoRouteMatched =
        GlobalConfiguration().getValue(GlobalVars.ERR_MESSAGE_NO_ROUTE_MATCHED);
    errMessageNoRouteMatched =
        GlobalConfiguration().getValue(GlobalVars.ERR_MESSAGE_NO_ROUTE_MATCHED);
  }
}
