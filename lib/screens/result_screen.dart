import 'package:flutter/material.dart';
import 'history_screen.dart'; // HistoryScreen import

class ResultScreen extends StatelessWidget {

  final String prediction;
  final double probability;

  const ResultScreen({
    Key? key,
    required this.prediction,
    required this.probability,
  }) : super(key: key);

  String getRiskLevel() {
    if (probability < 0.3) {
      return "Low Risk";
    } else if (probability < 0.6) {
      return "Moderate Risk";
    } else {
      return "High Risk";
    }
  }

  Color getRiskColor() {
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

    String riskLevel = getRiskLevel();
    Color riskColor = getRiskColor();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Prediction Result"),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            child: Padding(
              padding: const EdgeInsets.all(30),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Diabetes Risk Result",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    prediction,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Probability: ${(probability * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      riskLevel,
                      style: TextStyle(
                        fontSize: 18,
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Check Again Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Check Again"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // View History Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(),
                          ),
                        );
                      },
                      child: const Text("View History"),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}