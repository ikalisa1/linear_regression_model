import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://bikerental-fwp2.onrender.com/predict';

  static Future<String> predict(Map<String, String> inputData) async {
    final uri = Uri.parse(apiUrl);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(inputData
          .map((key, value) => MapEntry(key, num.tryParse(value) ?? 0))),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['predicted_rentals'].toString();
    } else {
      throw Exception('Failed to fetch prediction: ${response.body}');
    }
  }
}
