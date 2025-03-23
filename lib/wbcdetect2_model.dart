import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class WBCDetect2Model {
  Future<Map<String, dynamic>> runInference(File imageFile) async {
    final Uri apiUrl = Uri.parse("http://127.0.0.1:5000/predict");

    try {
      var request = http.MultipartRequest('POST', apiUrl);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200)
      {
        List<dynamic> jsonResponse = json.decode(responseData);

        if (jsonResponse.isNotEmpty && jsonResponse is List)
        {
          return jsonResponse.first as Map<String, dynamic>; // ✅ Extract the first map
        } else
        {
          throw Exception("Unexpected response format.");
        }
      }
      else
      {
        throw Exception("Failed to fetch results. HTTP Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}




// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// class WBCDetect2Model {
//   final String apiKey = "4WXqgLLRyHPBEVQpWlRr";
//   final String confidence = "50";
//
//   // Function for inference using the wbcdetect2 model
//   Future<Map<String, dynamic>> runInference(File imageFile) async {
//     final Uri apiUrl = Uri.parse(
//         "https://detect.roboflow.com/wbcdetect2/3?api_key=$apiKey&confidence=$confidence");
//
//     try {
//       List<int> imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);
//
//       final response = await http.post(
//         apiUrl,
//         body: base64Image,
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         return responseData; // Return the response data
//       } else {
//         throw Exception("Failed to fetch results.");
//       }
//     } catch (e) {
//       throw Exception("Error: $e");
//     }
//   }
// }
