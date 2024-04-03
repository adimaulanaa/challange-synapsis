// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? code;
  bool? status;
  String? message;
  Users? data;

  UserModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: Users.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Users {
  String? userId;
  String? nik;
  int? systemRoleId;
  String? systemRole;
  String? name;
  String? email;
  String? phone;
  String? departementId;
  String? departement;
  String? siteLocationId;
  String? siteLocation;

  Users({
    this.userId,
    this.nik,
    this.systemRoleId,
    this.systemRole,
    this.name,
    this.email,
    this.phone,
    this.departementId,
    this.departement,
    this.siteLocationId,
    this.siteLocation,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json["user_id"],
        nik: json["nik"],
        systemRoleId: json["system_role_id"],
        systemRole: json["system_role"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        departementId: json["departement_id"],
        departement: json["departement"],
        siteLocationId: json["site_location_id"],
        siteLocation: json["site_location"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nik": nik,
        "system_role_id": systemRoleId,
        "system_role": systemRole,
        "name": name,
        "email": email,
        "phone": phone,
        "departement_id": departementId,
        "departement": departement,
        "site_location_id": siteLocationId,
        "site_location": siteLocation,
      };
}
