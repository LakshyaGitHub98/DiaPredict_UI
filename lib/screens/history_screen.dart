import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> historyData = const [

    {
      "date": "10 March 2026",
      "glucose": 150,
      "age": 45,
      "prediction": "High Risk"
    },

    {
      "date": "05 March 2026",
      "glucose": 110,
      "age": 30,
      "prediction": "Low Risk"
    },

    {
      "date": "01 March 2026",
      "glucose": 135,
      "age": 38,
      "prediction": "Moderate Risk"
    },

  ];

  Color getRiskColor(String risk) {
    if (risk == "Low Risk") {
      return Colors.green;
    } else if (risk == "Moderate Risk") {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Prediction History"),
      ),

      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: historyData.length,

        itemBuilder: (context, index) {

          final item = historyData[index];
          final riskColor = getRiskColor(item["prediction"]);

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    item["date"],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Glucose: ${item["glucose"]}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  Text(
                    "Age: ${item["age"]}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 12),

                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Text(
                      item["prediction"],
                      style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}