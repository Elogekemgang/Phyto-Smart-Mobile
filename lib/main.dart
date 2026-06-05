import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phytosmart_mobile/screens/home.dart';
import 'package:phytosmart_mobile/screens/login.dart';
import 'package:phytosmart_mobile/screens/auth/loginscreen.dart';
import 'package:phytosmart_mobile/navigation.dart';
import 'package:phytosmart_mobile/screens/splashscreen.dart';
import 'package:phytosmart_mobile/services/notification_service.dart';
import 'package:phytosmart_mobile/testttttttttt.dart';
import 'package:timezone/data/latest.dart' as tz;



import 'services/storage_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  tz.initializeTimeZones();

  await NotificationService.init();

  runApp(const MyApp());
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  Future<bool> isLoggedIn() async {

    final token =
    await StorageService.getToken();
    await Future.delayed(Duration(seconds: 8));

    return token != null;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        //scaffoldBackgroundColor: Colors.white,
        //colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFFFFF)),
      ),

      debugShowCheckedModeBanner: false,

      home:
       //Navigation(),

      FutureBuilder(


        future: isLoggedIn(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const SplashScreen();
          }

          if (snapshot.data == true) {

            //return const Login();
            return const Navigation();
          }

          if (snapshot.hasError) {
            return const LoginScreen(); // En cas d'erreur, on force la reconnexion
          }

          return const LoginScreen();
        },
      ),
    );
  }
}