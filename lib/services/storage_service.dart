import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {

  static const FlutterSecureStorage storage =
  FlutterSecureStorage();

  static Future saveToken(
      String token,
      ) async {

    await storage.write(
      key: "token",
      value: token,
    );
  }

  static Future<String?> getToken() async {

    return await storage.read(
      key: "token",
    );
  }

  static Future clearToken() async {

    await storage.delete(
      key: "token",
    );
  }
}