// To parse this JSON data, do
//
//     final surveyModel = surveyModelFromJson(jsonString);

import 'dart:convert';

SurveyModel surveyModelFromJson(String str) =>
    SurveyModel.fromJson(json.decode(str));

String surveyModelToJson(SurveyModel data) => json.encode(data.toJson());

class SurveyModel {
  int? code;
  bool? status;
  int? page;
  int? count;
  int? totalData;
  String? message;
  List<Survey>? data;

  SurveyModel({
    this.code,
    this.status,
    this.page,
    this.count,
    this.totalData,
    this.message,
    this.data,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) => SurveyModel(
        code: json["code"],
        status: json["status"],
        page: json["page"],
        count: json["count"],
        totalData: json["total_data"],
        message: json["message"],
        data: List<Survey>.from(json["data"].map((x) => Survey.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "page": page,
        "count": count,
        "total_data": totalData,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Survey {
  String? id;
  String? name;
  DateTime? assessmentDate;
  String? description;
  String? type;
  int? roleAssessor;
  String? roleAssessorName;
  int? roleParticipant;
  String? roleParticipantName;
  String? departementId;
  String? departementName;
  String? siteLocationId;
  String? siteLocationName;
  String? image;
  List<Participant>? participants;
  dynamic assessors;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic downloadedAt;
  bool? hasResponses;

  Survey({
    this.id,
    this.name,
    this.assessmentDate,
    this.description,
    this.type,
    this.roleAssessor,
    this.roleAssessorName,
    this.roleParticipant,
    this.roleParticipantName,
    this.departementId,
    this.departementName,
    this.siteLocationId,
    this.siteLocationName,
    this.image,
    this.participants,
    this.assessors,
    this.createdAt,
    this.updatedAt,
    this.downloadedAt,
    this.hasResponses,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        id: json["id"],
        name: json["name"],
        assessmentDate: json["assessment_date"] == null
            ? null
            : DateTime.parse(json["assessment_date"]),
        description: json["description"],
        type: json["type"],
        roleAssessor: json["role_assessor"],
        roleAssessorName: json["role_assessor_name"],
        roleParticipant: json["role_participant"],
        roleParticipantName: json["role_participant_name"],
        departementId: json["departement_id"],
        departementName: json["departement_name"],
        siteLocationId: json["site_location_id"],
        siteLocationName: json["site_location_name"],
        image: json["image"],
        participants: json["participants"] == null
            ? null
            : List<Participant>.from(
                json["participants"].map((x) => Participant.fromJson(x))),
        assessors: json["assessors"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        downloadedAt: json["downloaded_at"],
        hasResponses: json["has_responses"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "assessment_date": assessmentDate.toString(),
        "description": description,
        "type": type,
        "role_assessor": roleAssessor,
        "role_assessor_name": roleAssessorName,
        "role_participant": roleParticipant,
        "role_participant_name": roleParticipantName,
        "departement_id": departementId,
        "departement_name": departementName,
        "site_location_id": siteLocationId,
        "site_location_name": siteLocationName,
        "image": image,
        "participants": participants == null
            ? null
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "assessors": assessors,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "downloaded_at": downloadedAt,
        "has_responses": hasResponses,
      };
}

class Participant {
  String? nik;
  String? name;
  String? departement;
  String? departementId;
  String? role;
  int? roleId;
  String? siteLocation;
  String? siteLocationId;
  int? totalAssessment;
  DateTime? lastAssessment;
  String? imageProfile;
  DateTime? createdAt;

  Participant({
    this.nik,
    this.name,
    this.departement,
    this.departementId,
    this.role,
    this.roleId,
    this.siteLocation,
    this.siteLocationId,
    this.totalAssessment,
    this.lastAssessment,
    this.imageProfile,
    this.createdAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        nik: json["nik"],
        name: json["name"],
        departement: json["departement"],
        departementId: json["departement_id"],
        role: json["role"],
        roleId: json["role_id"],
        siteLocation: json["site_location"],
        siteLocationId: json["site_location_id"],
        totalAssessment: json["total_assessment"],
        lastAssessment: DateTime.parse(json["last_assessment"]),
        imageProfile: json["image_profile"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "name": name,
        "departement": departement,
        "departement_id": departementId,
        "role": role,
        "role_id": roleId,
        "site_location": siteLocation,
        "site_location_id": siteLocationId,
        "total_assessment": totalAssessment,
        "last_assessment": lastAssessment.toString(),
        "image_profile": imageProfile,
        "created_at": createdAt.toString(),
      };
}
