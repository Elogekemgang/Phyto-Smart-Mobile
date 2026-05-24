import 'package:flutter/material.dart';

import '../models/diagnosis_model.dart';

import '../services/diagnosis_service.dart';

class HistoryScreen
    extends StatefulWidget {

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {

  final diagnosisService =
  DiagnosisService();

  List<DiagnosisModel> history = [];

  bool loading = true;

  Future loadHistory() async {

    try {

      final result =
      await diagnosisService
          .getHistory();

      setState(() {

        history = result;
      });

    } catch (e) {

      print(e);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {

    super.initState();

    loadHistory();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Historique",
        ),
      ),

      body: loading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : ListView.builder(

        itemCount:
        history.length,

        itemBuilder:
            (context, index) {

          final diagnosis =
          history[index];

          return Card(

            child: ListTile(

              title: Text(
                diagnosis.plantName,
              ),

              subtitle: Text(
                diagnosis.diseaseName,
              ),
            ),
          );
        },
      ),
    );
  }
}