import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/home.dart';
import 'package:phytosmart_mobile/navigation.dart';

import '../services/auth_service.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<Login> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final authService = AuthService();

  bool loading = false;

  Future login() async {

    setState(() {
      loading = true;
    });

    try {

      final response =
      await authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Navigation(),
        ),
      );
    } catch (e) {

      print(e);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connexion",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration:
              const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
              passwordController,
              obscureText: true,
              decoration:
              const InputDecoration(
                labelText: "Mot de passe",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed:
              loading ? null : login,

              child: loading
                  ? const CircularProgressIndicator()
                  : const Text(
                "Connexion",
              ),
            )
          ],
        ),
      ),
    );
  }
}