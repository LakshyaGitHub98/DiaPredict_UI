import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  Future<void> handleLogin() async {

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final result = await ApiService.login(email, password);

      print("LOGIN RESPONSE: $result");

      if (result["token"] != null) {

        await TokenService.saveToken(result["token"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"] ?? "Login failed")),
        );

      }

    } catch (e) {

      print("LOGIN ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "DiaPredict",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 40),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                );

              },
              child: const Text("Don't have an account? Sign Up"),
            )

          ],
        ),
      ),
    );
  }
}