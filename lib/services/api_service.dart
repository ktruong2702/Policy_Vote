// services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchQuestions() async {
  final response = await http.get(Uri.parse('http://localhost:8000/questions'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    return jsonResponse['questions'];
  } else {
    throw Exception('Failed to fetch questions');
  }
}
