class ParticipantModel {
  bool? isCaleg;

  ParticipantModel({
    this.isCaleg,
  });

  Map<String, dynamic> toJson() => {
        "is_caleg": isCaleg,
      };
}

class DashModel {
  int? totalIuran;
  int? totalWarga;

  DashModel({
    this.totalIuran,
    this.totalWarga,
  });

  Map<String, dynamic> toJson() => {
        "total_iuran": totalIuran,
        "total_warga": totalWarga,
      };
}
