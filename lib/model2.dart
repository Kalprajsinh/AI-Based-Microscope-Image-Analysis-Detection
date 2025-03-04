// model2.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Model2 {
  final String apiKey = "4WXqgLLRyHPBEVQpWlRr";
  final String confidence = "50";

  // Function for inference using model2
  Future<Map<String, dynamic>> runInference(File imageFile) async {
    final Uri apiUrl = Uri.parse(
        "https://detect.roboflow.com/model2/3?api_key=$apiKey&confidence=$confidence");

    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        apiUrl,
        body: base64Image,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData; // Return the response data
      } else {
        throw Exception("Failed to fetch results.");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
