import 'dart:io';

import 'package:dio/dio.dart';

import '../models/diagnosis_model.dart';

import 'api_service.dart';

class DiagnosisService {

  final ApiService api = ApiService();

  Future<DiagnosisModel> analyzeImage(
      File image,
      ) async {

    String fileName =
        image.path.split('/').last;

    FormData formData = FormData.fromMap({

      "file": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      )
    });

    try {

    final response = await api.dio.post(
      "/diagnosis/analyze",
      data: formData,
    );

    if (response.data["status"] == "warning") {
      // Ce "throw" va remonter jusqu'au "catch (e)" de ton DiagnosisScreen
      // et affichera ton SnackBar avec le message de l'IA !
      throw Exception(response.data["message"]);
      //return DiagnosisModel(plantName: "plantName", diseaseName: "diseaseName", confidence: "confidence", treatment: "treatment");
    }

    // 2. Si c'est un succès absolu
    if (response.data["status"] == "success") {
      return DiagnosisModel.fromJson(
        response.data["data"],
      );
    }
    throw Exception("Format de réponse inattendu.");

    } on DioException catch (e) {
      // DioException permet d'attraper les erreurs HTTP (comme une erreur 500 ou 400)
      throw Exception(e.response?.data['detail'] ?? "Erreur de connexion au serveur");
    }


  }

  Future<List<DiagnosisModel>>
  getHistory() async {

    final response = await api.dio.get(
      "/diagnosis/history",
    );

    return (response.data as List)
        .map(
          (e) => DiagnosisModel.fromJson(e),
    )
        .toList();
  }
  
}