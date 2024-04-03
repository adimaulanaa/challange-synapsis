import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';
import 'package:synapsis/framework/managers/hive_db_helper.dart';
import 'package:synapsis/framework/managers/realm_config/realm_db_helper.dart';

abstract class AuthLocalDataSource {
  Future<void> persistToken(UserModel userData);
  Future<bool> isSignedIn();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbService,
    required this.realmDbService,
  });

  final HiveDbServices dbService;
  final SharedPreferences sharedPreferences;
  final RealmDBServices realmDbService;

  @override
  Future<bool> isSignedIn() async {
    /// read from keystore/keychain
    await Future.delayed(const Duration(seconds: 1));
    var hasUserLogin = await dbService.hasData(HiveDbServices.boxToken);
    var isSignedIn = hasUserLogin;
    return isSignedIn;
  }

  @override
  Future<void> persistToken(UserModel userData) async {
    /// write to keystore/keychain
    Users data = userData.data!;
    await realmDbService.session(data, false);
    sharedPreferences.setString('last_username', data.name!);
    await dbService.addData(HiveDbServices.boxUsername, data.name!);
    await dbService.addData(HiveDbServices.boxToken, data.userId!);
    return;
  }

  @override
  Future<void> clearToken() async {
    /// delete from keystore/keychain
    await Future.delayed(const Duration(seconds: 1));
    await dbService.deleteData(HiveDbServices.boxUsername);
    await dbService.deleteData(HiveDbServices.boxUsername);
    await dbService.deleteData(HiveDbServices.boxRefreshToken);
    return;
  }
}
