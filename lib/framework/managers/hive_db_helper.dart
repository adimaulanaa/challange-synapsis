// ignore_for_file: unnecessary_null_comparison

import 'package:hive/hive.dart';
import 'dart:async';

class HiveDbServices {
  static const String boxConfig = 'DAC_Config';
  static const String boxDeviceInfo = 'DAC_DeviceInfo';
  static const String boxIsLogin = 'DAC_IsLogin';
  static const String boxLastUsernameLoggedIn = 'DAC_LastUsernameLoggedIn';
  static const String boxLoggedInUser = 'DAC_UserLoggedIn';
  static const String boxConfigTenant = 'DAC_ConfigTenant';
  static const String boxUsername = 'DAC_Username';
  static const String boxToken = 'DAC_Token';
  static const String boxRefreshToken = 'DAC_Refresh_Token';
  static const String boxHome = 'DAC_Home';

  //====
  static const String boxDashboard = 'DAC_Dashboard';
  static const String boxSurvey = 'DAC_Survey';
  static const String boxConfiguration = 'DAC_Configuration';
  static const String boxDashboardChart = 'DAC_Dashboard_Chart';
  static const String boxCashBook = 'DAC_CashBook';
  static const String boxDeposit = 'DAC_Deposit';
  static const String boxDues = 'DAC_Dues';
  static const String boxFinancialStatement = 'DAC_FinancialStatement';
  static const String boxCaretaker = 'DAC_Caretaker';
  static const String boxCategory = 'DAC_Category';
  static const String boxHouse = 'DAC_House';
  static const String boxOfficer = 'DAC_Officer';
  static const String boxSubscription = 'DAC_Subscription';
  static const String boxProfile = 'DAC_Profile';
  static const String boxGuest = 'DAC_Guest';
  static const String boxVisitor = 'DAC_Visitor';
  static const String boxBroadcast = 'DAC_Broadcast';
  static const String boxAbout = 'DAC_About';
  static const String boxComplaint = 'DAC_Complaint';
  static const String boxFirebaseToken = 'DAC_FirebaseToken';
  static const String boxNotification = 'DAC_Notification';
  static const String boxConfirmation = 'DAC_Confirmation';
  static const String boxVoter = 'DAC_Voter';
  static const String boxImpersonate = 'DAC_Impersonate';
  static const String boxImpersonateVolunteer = 'DAC_ImpersonateVolunteer';

  //! Type ID
  static const int hiveTypeDashboard = 1;
  static const int hiveTypeRegion = 2;
  static const int hiveTypeUser = 3;
  Future<Box> _openBox(String key) async => await Hive.openBox(key);
  Future<bool> addData(String key, dynamic data) async {
    var box = await _openBox(key);
    bool isSaved = false;
    if (data != null) {
      var inserted = box.put(key, data);
      isSaved = inserted != null ? true : false;
    }
    return isSaved;
  }

  Future<dynamic> getData(String key) async {
    var box = await _openBox(key);
    return box.get(key);
  }

  Future<bool> hasData(String key) async {
    var box = await _openBox(key);
    var value = box.get(key);
    return (value != null ? true : false);
  }

  Future<void> deleteData(String key) async {
    var box = await _openBox(key);
    var data = box.delete(key);
    return data;
  }

  //! User
  Future<Box> userBox() async => await Hive.openBox(boxLoggedInUser);

  Future<bool> addUser(String data) async {
    var box = await userBox();
    bool isSaved = false;
    if (data != null) {
      var inserted = box.put('user', data);
      isSaved = inserted != null ? true : false;
    }
    return isSaved;
  }

  Future<String> getUser() async {
    var box = await userBox();
    return box.get('user');
  }

  Future<bool> hasUser() async {
    var box = await userBox();
    var value = box.get('user');
    return (value != null ? true : false);
  }

  Future<void> deleteUser() async {
    var box = await userBox();
    var data = box.delete('user');
    return data;
  }
}
