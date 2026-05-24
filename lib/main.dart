import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/home.dart';
import 'package:phytosmart_mobile/screens/login.dart';
import 'package:phytosmart_mobile/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;



import 'services/storage_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  Future<bool> isLoggedIn() async {

    final token =
    await StorageService.getToken();

    return token != null;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: FutureBuilder(

        future: isLoggedIn(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Scaffold(
              body: Center(
                child:
                CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            );
          }

          if (snapshot.data == true) {

            return Home();
          }

          return const Login();
        },
      ),
    );
  }
}