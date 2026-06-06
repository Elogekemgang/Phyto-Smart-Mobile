class DiagnosisModel {
  final String plantName;

  final String diseaseName;

  final String confidence;

  final String treatment;

  final int? id;

  final int? durationDays;

  final int? recommendedHour;

  final String dosage;
  final String duration;
  final String frequency;
  final String prevention;
  final String riskLevel;

  DiagnosisModel({
    this.id,
    this.durationDays,
    this.recommendedHour,
    required this.plantName,
    required this.diseaseName,
    required this.confidence,
    required this.treatment,
    required this.dosage,
    required this.duration,
    required this.frequency,
    required this.prevention,
    required this.riskLevel,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      id: json["id"],

      durationDays: json["duration_days"],

      recommendedHour: json["recommended_hour"],

      plantName: json["plant_name"],

      diseaseName: json["disease_name"],

      confidence: json["confidence"],

      treatment: json["treatment"],
      dosage: json["dosage"],
      duration: json["duration"],
      frequency: json["frequency"],
      prevention: json["prevention"],
      riskLevel: json["risk_level"],
    );
  }
}
