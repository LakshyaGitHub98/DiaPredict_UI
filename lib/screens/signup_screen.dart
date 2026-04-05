import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool isLoading = false;

  Future<void> handleSignup() async {

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirm = confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );

      return;
    }

    if (password != confirm) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final result = await ApiService.signup(name, email, password);

      if (result["message"] != null) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"])),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup failed")),
        );

      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error")),
      );

    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

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

            const SizedBox(height: 20),

            TextField(
              controller: confirmController,
              obscureText: !isConfirmVisible,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isConfirmVisible = !isConfirmVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleSignup,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up"),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );

              },
              child: const Text("Already have an account? Login"),
            )

          ],
        ),
      ),
    );
  }
}