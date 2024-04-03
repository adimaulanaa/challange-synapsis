// Run
// fvm dart run realm generate

import 'package:realm/realm.dart';

part 'session_model.g.dart';

@RealmModel()
class _SessionModelRealm {
  late String userId;
  late String nik;
  late int systemRoleId;
  late String systemRole;
  late String name;
  late String email;
  late String phone;
  late String departementId;
  late String departement;
  late String siteLocationId;
  late String siteLocation;
  late bool autoSign;
}
