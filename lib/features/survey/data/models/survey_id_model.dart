// To parse this JSON data, do
//
//     final surveyIdModel = surveyIdModelFromJson(jsonString);

import 'dart:convert';

SurveyIdModel surveyIdModelFromJson(String str) =>
    SurveyIdModel.fromJson(json.decode(str));

String surveyIdModelToJson(SurveyIdModel data) => json.encode(data.toJson());

class SurveyIdModel {
  int? code;
  bool? status;
  String? message;
  SurveyId? data;

  SurveyIdModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory SurveyIdModel.fromJson(Map<String, dynamic> json) => SurveyIdModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: SurveyId.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class SurveyId {
  String? id;
  String? name;
  List<Question>? question;

  SurveyId({
    this.id,
    this.name,
    this.question,
  });

  factory SurveyId.fromJson(Map<String, dynamic> json) => SurveyId(
        id: json["id"],
        name: json["name"],
        question: List<Question>.from(
            json["question"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "question": List<dynamic>.from(question!.map((x) => x.toJson())),
      };
}

class Question {
  String? questionid;
  String? section;
  String? number;
  String? type;
  String? questionName;
  bool? scoring;
  List<Option>? options;

  Question({
    this.questionid,
    this.section,
    this.number,
    this.type,
    this.questionName,
    this.scoring,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionid: json["questionid"],
        section: json["section"],
        number: json["number"],
        type: json["type"],
        questionName: json["question_name"],
        scoring: json["scoring"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questionid": questionid,
        "section": section,
        "number": number,
        "type": type,
        "question_name": questionName,
        "scoring": scoring,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class Option {
  String? optionid;
  String? optionName;
  int? points;
  int? flag;
  bool check;
  dynamic siteLocationIds;

  Option({
    this.optionid,
    this.optionName,
    this.points,
    this.flag,
    this.check = false,
    this.siteLocationIds,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionid: json["optionid"],
        optionName: json["option_name"],
        points: json["points"],
        flag: json["flag"],
        siteLocationIds: json["site_location_ids"],
      );

  Map<String, dynamic> toJson() => {
        "optionid": optionid,
        "option_name": optionName,
        "points": points,
        "flag": flag,
        "site_location_ids": siteLocationIds,
      };
}
