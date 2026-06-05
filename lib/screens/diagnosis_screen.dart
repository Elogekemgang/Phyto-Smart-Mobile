import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../models/diagnosis_model.dart';

import '../services/diagnosis_service.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  File? image;

  DiagnosisModel? diagnosis;

  bool loading = false;

  final picker = ImagePicker();

  final diagnosisService = DiagnosisService();

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);

      diagnosis = null;
    });
  }

  Future analyzeImage() async {
    if (image == null) return;

    setState(() {
      loading = true;
      diagnosis = null; // On réinitialise l'ancien diagnostic
    });

    try {
      final result = await diagnosisService.analyzeImage(image!);

      setState(() {
        diagnosis = result;
      });
    } catch (e) {
      // Si le backend renvoie un "warning" ou si la requête échoue,
      // on affiche le message personnalisé de l'IA via un SnackBar.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.orange.shade800, // Couleur d'avertissement
            duration: const Duration(seconds: 4),
          ),
        );
      }
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diagnostic")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            if (image != null) Image.file(image!, height: 250),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.gallery),

                  child: const Text("Galerie"),
                ),

                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.camera),

                  child: const Text("Caméra"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: loading ? null : analyzeImage,

              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Analyser"),
            ),

            const SizedBox(height: 30),

            if (diagnosis != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Plante : ${diagnosis!.plantName}"),

                      const SizedBox(height: 10),

                      Text("Maladie : ${diagnosis!.diseaseName}"),

                      const SizedBox(height: 10),

                      Text("Confiance : ${diagnosis!.confidence}"),

                      const SizedBox(height: 10),

                      Text("Traitement : ${diagnosis!.treatment}"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
