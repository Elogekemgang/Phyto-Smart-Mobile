import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import '../services/notification_service.dart';
import 'diagnosis_screen.dart';
import 'history.dart';
import 'login.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final authService = AuthService();

  Future logout(BuildContext context) async {
    await authService.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agro AI"),

        actions: [
          IconButton(
            onPressed: () => logout(context),

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DiagnosisScreen()),
                );
              },

              child: const Text("Diagnostic plante"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },

              child: const Text("Historique"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationService.showNotification(
                  id: 1,

                  title: "Traitement agricole",

                  body: "Pulvériser insecticide XYZ",
                );
              },

              child: const Text("Tester notification"),
            ),
          ],
        ),
      ),
    );
  }
}
