class DiagnosisModel {

  final String plantName;

  final String diseaseName;

  final String confidence;

  final String treatment;

  DiagnosisModel({
    required this.plantName,
    required this.diseaseName,
    required this.confidence,
    required this.treatment,
  });

  factory DiagnosisModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return DiagnosisModel(
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