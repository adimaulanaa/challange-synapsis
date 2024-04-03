// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class SessionModelRealm extends _SessionModelRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  SessionModelRealm(
    String userId,
    String nik,
    int systemRoleId,
    String systemRole,
    String name,
    String email,
    String phone,
    String departementId,
    String departement,
    String siteLocationId,
    String siteLocation,
    bool autoSign,
  ) {
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'nik', nik);
    RealmObjectBase.set(this, 'systemRoleId', systemRoleId);
    RealmObjectBase.set(this, 'systemRole', systemRole);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'phone', phone);
    RealmObjectBase.set(this, 'departementId', departementId);
    RealmObjectBase.set(this, 'departement', departement);
    RealmObjectBase.set(this, 'siteLocationId', siteLocationId);
    RealmObjectBase.set(this, 'siteLocation', siteLocation);
    RealmObjectBase.set(this, 'autoSign', autoSign);
  }

  SessionModelRealm._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get nik => RealmObjectBase.get<String>(this, 'nik') as String;
  @override
  set nik(String value) => RealmObjectBase.set(this, 'nik', value);

  @override
  int get systemRoleId => RealmObjectBase.get<int>(this, 'systemRoleId') as int;
  @override
  set systemRoleId(int value) =>
      RealmObjectBase.set(this, 'systemRoleId', value);

  @override
  String get systemRole =>
      RealmObjectBase.get<String>(this, 'systemRole') as String;
  @override
  set systemRole(String value) =>
      RealmObjectBase.set(this, 'systemRole', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get phone => RealmObjectBase.get<String>(this, 'phone') as String;
  @override
  set phone(String value) => RealmObjectBase.set(this, 'phone', value);

  @override
  String get departementId =>
      RealmObjectBase.get<String>(this, 'departementId') as String;
  @override
  set departementId(String value) =>
      RealmObjectBase.set(this, 'departementId', value);

  @override
  String get departement =>
      RealmObjectBase.get<String>(this, 'departement') as String;
  @override
  set departement(String value) =>
      RealmObjectBase.set(this, 'departement', value);

  @override
  String get siteLocationId =>
      RealmObjectBase.get<String>(this, 'siteLocationId') as String;
  @override
  set siteLocationId(String value) =>
      RealmObjectBase.set(this, 'siteLocationId', value);

  @override
  String get siteLocation =>
      RealmObjectBase.get<String>(this, 'siteLocation') as String;
  @override
  set siteLocation(String value) =>
      RealmObjectBase.set(this, 'siteLocation', value);

  @override
  bool get autoSign => RealmObjectBase.get<bool>(this, 'autoSign') as bool;
  @override
  set autoSign(bool value) => RealmObjectBase.set(this, 'autoSign', value);

  @override
  Stream<RealmObjectChanges<SessionModelRealm>> get changes =>
      RealmObjectBase.getChanges<SessionModelRealm>(this);

  @override
  SessionModelRealm freeze() =>
      RealmObjectBase.freezeObject<SessionModelRealm>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SessionModelRealm._);
    return const SchemaObject(
        ObjectType.realmObject, SessionModelRealm, 'SessionModelRealm', [
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('nik', RealmPropertyType.string),
      SchemaProperty('systemRoleId', RealmPropertyType.int),
      SchemaProperty('systemRole', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('phone', RealmPropertyType.string),
      SchemaProperty('departementId', RealmPropertyType.string),
      SchemaProperty('departement', RealmPropertyType.string),
      SchemaProperty('siteLocationId', RealmPropertyType.string),
      SchemaProperty('siteLocation', RealmPropertyType.string),
      SchemaProperty('autoSign', RealmPropertyType.bool),
    ]);
  }
}
