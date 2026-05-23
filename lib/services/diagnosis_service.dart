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

    final response = await api.dio.post(
      "/diagnosis/analyze",
      data: formData,
    );

    return DiagnosisModel.fromJson(
      response.data["data"],
    );
  }
}