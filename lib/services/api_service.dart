import 'package:dio/dio.dart';

import '../core/constants.dart';

import 'storage_service.dart';

class ApiService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
    ),
  );

  ApiService() {

    dio.interceptors.add(
      InterceptorsWrapper(

        onRequest: (
            options,
            handler,
            ) async {

          final token =
          await StorageService.getToken();

          if (token != null) {

            options.headers[
            "Authorization"] =
            "Bearer $token";
          }

          return handler.next(
            options,
          );
        },
      ),
    );
  }
}