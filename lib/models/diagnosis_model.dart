class DiagnosisModel {

  final String plantName;

  final String diseaseName;

  final String confidence;

  final String treatment;

  final int? id;

  final int? durationDays;

  final int? recommendedHour;

  DiagnosisModel({
    this.id,
    this.durationDays,
    this.recommendedHour,
    required this.plantName,
    required this.diseaseName,
    required this.confidence,
    required this.treatment

  });

  factory DiagnosisModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return DiagnosisModel(
      id: json["id"],

      durationDays:
      json["duration_days"],

      recommendedHour:
      json["recommended_hour"],

      plantName:
      json["plant_name"],

      diseaseName:
      json["disease_name"],

      confidence:
      json["confidence"],

      treatment:
      json["treatment"],
    );
  }
}