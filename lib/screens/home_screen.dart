import 'package:flutter/material.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  // Controllers for Prediction Form
  final _formKey = GlobalKey<FormState>();
  final pregnanciesController = TextEditingController();
  final glucoseController = TextEditingController();
  final bpController = TextEditingController();
  final skinController = TextEditingController();
  final insulinController = TextEditingController();
  final bmiController = TextEditingController();
  final dpfController = TextEditingController();
  final ageController = TextEditingController();

  // Tab Screens
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      _predictionForm(), // Prediction Form Tab
      const HistoryScreen(), // History Tab
    ];
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

  void predictRisk() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "pregnancies": pregnanciesController.text,
        "glucose": glucoseController.text,
        "blood_pressure": bpController.text,
        "skin_thickness": skinController.text,
        "insulin": insulinController.text,
        "bmi": bmiController.text,
        "dpf": dpfController.text,
        "age": ageController.text,
      };
      print(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Prediction request sent (dummy)"),
        ),
      );
    }
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
                onPressed: predictRisk,
                child: const Text(
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

      body: _pages[_selectedIndex],

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