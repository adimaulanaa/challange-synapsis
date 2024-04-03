import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:synapsis/features/auth/data/models/user_model.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/managers/realm_config/model/session_model.dart';

DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy-MM-dd').format(now);

class RealmDBServices {
  Future<Realm> _openDB() async {
    final config = Configuration.local([
      // ! model
      SessionModelRealm.schema,
    ]);
    return Realm(config);
  }

  Future<Realm> getRealm() async {
    return await _openDB();
  }

  Future<void> closeRealm() async {
    final realm = await _openDB();
    realm.close();
  }

  //! drop db

  Future<bool> deleteAll() async {
    final realm = await _openDB();
    realm.write(() {
      realm.deleteAll<SessionModelRealm>();
    });
    printError('delete all');
    return true;
  }

  // ! Add

  Future<void> session(Users dt, bool autoSign) async {
    final realm = await _openDB();
    realm.write(() {
      realm.add(
        SessionModelRealm(
          dt.userId.toString(),
          dt.nik.toString(),
          dt.systemRoleId!.toInt(),
          dt.systemRole.toString(),
          dt.name.toString(),
          dt.email.toString(),
          dt.phone.toString(),
          dt.departementId.toString(),
          dt.departement.toString(),
          dt.siteLocationId.toString(),
          dt.siteLocation.toString(),
          autoSign,
        ),
      );
    });
  }

  // ! Delete
}
