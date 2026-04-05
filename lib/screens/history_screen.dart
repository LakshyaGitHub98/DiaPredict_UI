import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  List history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {

    try {

      String? token = await TokenService.getToken();

      final result = await ApiService.getHistory(token!);

      print("HISTORY DATA: $result"); // 🔥 debug

      setState(() {
        history = result;
        isLoading = false;
      });

    } catch (e) {

      print("HISTORY ERROR: $e");

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load history")),
      );
    }
  }

  String getRiskLevel(double probability) {
    if (probability < 0.3) {
      return "Low Risk";
    } else if (probability < 0.6) {
      return "Moderate Risk";
    } else {
      return "High Risk";
    }
  }

  Color getRiskColor(double probability) {
    if (probability < 0.3) {
      return Colors.green;
    } else if (probability < 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (history.isEmpty) {
      return const Center(
        child: Text("No prediction history found"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {

        final item = history[index];

        // ✅ FIXED
        double probability = (item["risk"] ?? 0) / 100;

        String prediction =
        item["prediction"] == 1 ? "Diabetic" : "Non-Diabetic";

        String riskLevel = getRiskLevel(probability);
        Color riskColor = getRiskColor(probability);

        return Card(
          key: ValueKey(item["_id"]), // ✅ important fix
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              Icons.medical_services,
              color: riskColor,
            ),

            title: Text(prediction),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Probability: ${(probability * 100).toStringAsFixed(1)}%",
                ),
                Text(
                  "Age: ${item["age"]}, Glucose: ${item["glucose"]}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            trailing: Text(
              riskLevel,
              style: TextStyle(
                color: riskColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}