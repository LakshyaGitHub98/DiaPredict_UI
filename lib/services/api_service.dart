import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      "https://diapredict-backend-ve3w.onrender.com/api";

  // =========================
  // LOGIN API
  // =========================
  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    return _handleResponse(response);
  }

  // =========================
  // SIGNUP API
  // =========================
  static Future<Map<String, dynamic>> signup(
      String name,
      String email,
      String password,
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/auth/signup"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password
      }),
    );

    return _handleResponse(response);
  }

  // =========================
  // PREDICT API
  // =========================
  static Future<Map<String, dynamic>> predict(
      List features,
      String token,
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/predict/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "features": features
      }),
    );

    return _handleResponse(response);
  }

  // =========================
  // HISTORY API
  // =========================
  static Future<List<dynamic>> getHistory(
      String token,
      ) async {

    final response = await http.get(
      Uri.parse("$baseUrl/predict/history"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    print("HISTORY STATUS: ${response.statusCode}");
    print("HISTORY BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load history");
    }
  }

  // =========================
  // COMMON HANDLER
  // =========================
  static Map<String, dynamic> _handleResponse(http.Response response) {

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Something went wrong");
    }
  }
}