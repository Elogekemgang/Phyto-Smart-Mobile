import 'package:dio/dio.dart';

import 'api_service.dart';

import 'storage_service.dart';

class AuthService {

  final ApiService api = ApiService();

  Future register({
    required String name,
    required String email,
    required String password,
  }) async {

    return await api.dio.post(
      "/auth/register",
      data: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
  }

  Future login({
    required String email,
    required String password,
  }) async {

    final response = await api.dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    final token =
    response.data["access_token"];

    await StorageService.saveToken(
      token,
    );

    return response;
  }

  Future logout() async {

    await StorageService.clearToken();
  }
}