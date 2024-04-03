import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TenantData extends Equatable {
  TenantData({
    required this.id,
    required this.name,
    required this.picture,
    required this.isSelected,
  });

  int? id;
  String? name;
  String? picture;
  bool? isSelected;

  @override
  List<Object> get props => [
        id!,
        name!,
        picture!,
        isSelected!,
      ];
}

class CashBookData extends Equatable {
  const CashBookData({
    required this.yearStart,
    required this.monthStart,
    this.monthEnd,
    this.yearEnd,
    this.isPdf,
    this.village,
    this.rtPlace,
    this.rwPlace,
    this.type,
  });

  final int? monthStart;
  final int? yearStart;
  final int? monthEnd;
  final int? yearEnd;
  final bool? isPdf;
  final String? type;
  final List<String>? village;
  final List<String>? rtPlace;
  final List<String>? rwPlace;

  @override
  List<Object> get props => [
        monthStart!,
        yearStart!,
        monthEnd!,
        yearEnd!,
        isPdf!,
        type!,
        rtPlace!,
        rwPlace!,
        village!,
      ];
}

class CandidateData extends Equatable {
  const CandidateData({
    this.candidateName,
    this.parlimenName,
    this.birthDate,
    this.birthPlace,
    this.age,
    this.education,
    this.organisationExperience,
    this.carierExperience,
    this.visionMision,
    this.candidateImage,
  });

  final String? candidateName;
  final String? parlimenName;
  final String? birthDate;
  final String? birthPlace;
  final int? age;
  final String? education;
  final String? organisationExperience;
  final String? carierExperience;
  final String? visionMision;
  final String? candidateImage;

  @override
  List<Object> get props => [
        candidateName!,
        parlimenName!,
        birthDate!,
        birthPlace!,
        age!,
        education!,
        organisationExperience!,
        carierExperience!,
        visionMision!,
        candidateImage!,
      ];
}
