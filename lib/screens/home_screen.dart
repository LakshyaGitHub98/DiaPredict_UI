import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'result_screen.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final pregnanciesController = TextEditingController();
  final glucoseController = TextEditingController();
  final bpController = TextEditingController();
  final skinController = TextEditingController();
  final insulinController = TextEditingController();
  final bmiController = TextEditingController();
  final dpfController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    pregnanciesController.dispose();
    glucoseController.dispose();
    bpController.dispose();
    skinController.dispose();
    insulinController.dispose();
    bmiController.dispose();
    dpfController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> predictRisk() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {

      String? token = await TokenService.getToken();
      print("TOKEN: $token");

      List features = [
        int.parse(pregnanciesController.text),
        int.parse(glucoseController.text),
        int.parse(bpController.text),
        int.parse(skinController.text),
        int.parse(insulinController.text),
        double.parse(bmiController.text),
        double.parse(dpfController.text),
        int.parse(ageController.text),
      ];

      final result = await ApiService.predict(features, token!);

      print("PREDICT RESPONSE: $result");

      // ✅ FIXED
      String prediction =
      result["prediction"] == 1 ? "Diabetic" : "Non-Diabetic";

      double probability = (result["risk"] ?? 0) / 100;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            prediction: prediction,
            probability: probability,
          ),
        ),
      );

    } catch (e) {

      print("PREDICT ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Prediction failed: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget _predictionForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [

            buildInput("Pregnancies", pregnanciesController),
            buildInput("Glucose Level", glucoseController),
            buildInput("Blood Pressure", bpController),
            buildInput("Skin Thickness", skinController),
            buildInput("Insulin", insulinController),
            buildInput("BMI", bmiController),
            buildInput("Diabetes Pedigree Function", dpfController),
            buildInput("Age", ageController),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : predictRisk,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Predict Diabetes Risk",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("DiaPredict"),
        backgroundColor: Colors.blue,
      ),

      body: _selectedIndex == 0
          ? _predictionForm()
          : const HistoryScreen(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Predict",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
      ),
    );
  }
}