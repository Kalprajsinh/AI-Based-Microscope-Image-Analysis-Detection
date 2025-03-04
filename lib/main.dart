import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'wbcdetect2_model.dart';
import 'model2.dart';
import 'model3.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const InferenceScreen(),
    );
  }
}

class InferenceScreen extends StatefulWidget {
  const InferenceScreen({super.key});

  @override
  State<InferenceScreen> createState() => _InferenceScreenState();
}

class _InferenceScreenState extends State<InferenceScreen> {
  String selectedModel = 'WBC Detection';
  final List<String> availableModels = ['WBC Detection', 'Model2', 'Model3'];

  File? inputImage;
  Uint8List? outputImage;
  bool isLoading = false;
  List<Map<String, dynamic>> detections = [];

  // Select Image
  Future<void> pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedFile != null) {
      setState(() {
        inputImage = File(pickedFile.files.single.path!);
        outputImage = null;
        detections = [];
      });
    }
  }

  // Run Inference
  Future<void> runInference() async {
    if (inputImage == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      detections = [];
      outputImage = null;
    });

    try {
      Map<String, dynamic> responseData = {};

      if (selectedModel == 'WBC Detection') {
        WBCDetect2Model model = WBCDetect2Model();
        responseData = await model.runInference(inputImage!);
      } else if (selectedModel == 'Model2') {
        Model2 model = Model2();
        responseData = await model.runInference(inputImage!);
      } else if (selectedModel == 'Model3') {
        Model3 model = Model3();
        responseData = await model.runInference(inputImage!);
      }

      if (responseData.isNotEmpty) {
        setState(() {
          detections = (responseData["classification_predictions"] as List)
              .map<Map<String, dynamic>>((d) => {
            "class": d["top"],
            "confidence": "${(d["confidence"] * 100).toStringAsFixed(2)}%"
          })
              .toList();

          if (responseData.containsKey("output_image")) {
            outputImage = base64Decode(responseData["output_image"]);
          }
        });
      }
    } catch (e) {
      setState(() {
        detections = [];
      });
      print("Error in inference: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          // Top Menu Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: const Border(bottom: BorderSide(color: Colors.white, width: 1)),
            ),
            child: Row(
              children: [
                _buildMenuButton("File", ["Open", "New", "Exit"]),
                _buildMenuButton("Help", ["Documentation", "About"]),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Row(
              children: [
                // Sidebar Controls
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: const Border(right: BorderSide(color: Colors.white24)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text("Upload Image"),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: runInference,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Run Inference"),
                      ),
                      const SizedBox(height: 20),
                      // Dropdown for Model Selection
                      DropdownButton<String>(
                        value: selectedModel,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedModel = newValue!;
                          });
                        },
                        items: availableModels
                            .map<DropdownMenuItem<String>>(
                                (String model) => DropdownMenuItem<String>(
                              value: model,
                              child: Text(model),
                            ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                // Image Display Panel
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Input Image Panel
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Center(
                                  child: inputImage != null
                                      ? Image.file(inputImage!)
                                      : const Text("Upload an Image",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: outputImage != null
                            ? Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Center(
                                  child:  Image.memory(outputImage!)

                                ),
                              ) : const Text("",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      // Bottom Panel: Display Inference Result
                      SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            border: const Border(top: BorderSide(color: Colors.white24)),
                          ),
                          child: detections.isNotEmpty
                              ? SingleChildScrollView(
                                child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                const Text("Detected Classes:",
                                    style: TextStyle(color: Colors.white, fontSize: 16)),
                                ...detections.map((detection) => Text(
                                  "${detection["class"]}: ${detection["confidence"]}",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ))
                                                            ],
                                                          ),
                              )
                              : const Text("Inference results will be displayed here.",
                              style: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, List<String> options) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (title == "File") {
          if (value == "Open") {
            pickImage();
          } else if (value == "New") {
            setState(() {
              inputImage = null;
              outputImage = null;
              detections = [];
            });
          } else if (value == "Exit") {
            exit(0);
          }
        }
      },
      itemBuilder: (context) =>
          options.map((option) => PopupMenuItem(value: option, child: Text(option))).toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}










// import 'dart:convert';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: InferenceScreen(),
//     );
//   }
// }
//
// class InferenceScreen extends StatefulWidget {
//   @override
//   _InferenceScreenState createState() => _InferenceScreenState();
// }
//
// class _InferenceScreenState extends State<InferenceScreen> {
//   final String model = "wbcdetect2";
//   final String version = "3";
//   final String apiKey = "4WXqgLLRyHPBEVQpWlRr";
//   final String confidence = "50";
//
//   File? inputImage;
//   String? result;
//   bool isLoading = false;
//   List<dynamic> detections = [];
//   bool showResults = false;
//   int originalWidth = 1;
//   int originalHeight = 1;
//
//   Future<void> pickImage() async {
//     final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (pickedFile != null) {
//       setState(() {
//         inputImage = File(pickedFile.files.single.path!);
//         result = null;
//         detections = [];
//         showResults = false;
//       });
//     }
//   }
//
//   Future<void> runInference() async {
//     if (inputImage == null) {
//       setState(() {
//         result = "Please select an image first.";
//       });
//       return;
//     }
//
//     setState(() {
//       result = null;
//       isLoading = true;
//       showResults = false;
//     });
//
//     final Uri apiUrl = Uri.parse(
//         "https://detect.roboflow.com/$model/$version?api_key=$apiKey&confidence=$confidence");
//
//     try {
//       List<int> imageBytes = await inputImage!.readAsBytes();
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
//         originalWidth = responseData['image']['width'];
//         originalHeight = responseData['image']['height'];
//
//         setState(() {
//           result = response.body;
//           detections = responseData['predictions'] ?? [];
//           showResults = true;
//         });
//       } else {
//         setState(() {
//           result = "Failed to fetch results. Try again.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         result = "Error: $e";
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
//             ),
//             child: Row(
//               children: [
//                 _buildMenuButton("File", ["Open", "New", "Exit"]),
//                 _buildMenuButton("Help", ["Documentation", "About"]),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Row(
//               children: [
//                 Container(
//                   width: 250,
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[900],
//                     border: Border(right: BorderSide(color: Colors.white24)),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: pickImage,
//                         child: Text("Upload Image"),
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: runInference,
//                         child: isLoading
//                             ? CircularProgressIndicator(color: Colors.white)
//                             : Text("Run Inference"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 margin: EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.white24),
//                                 ),
//                                 child: Center(
//                                   child: inputImage != null
//                                       ? Image.file(inputImage!)
//                                       : Text("Upload an Image", style: TextStyle(color: Colors.white)),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SingleChildScrollView(
//                         child: Container(
//                           padding: EdgeInsets.all(16),
//                           width: double.infinity,
//                           height: 200,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[850],
//                             border: Border(top: BorderSide(color: Colors.white24)),
//                           ),
//                           child: result != null
//                               ? SingleChildScrollView(
//                             child: Text("Result:\n$result", style: TextStyle(color: Colors.white)),
//                           )
//                               : Text("Inference results will be displayed here.", style: TextStyle(color: Colors.white54)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuButton(String title, List<String> options) {
//     return PopupMenuButton<String>(
//       onSelected: (value) {
//         if (title == "File") {
//           if (value == "Open") {
//             pickImage();
//           } else if (value == "New") {
//             setState(() {
//               inputImage = null;
//               result = null;
//               detections = [];
//               showResults = false;
//             });
//           } else if (value == "Exit") {
//             exit(0);
//           }
//         }
//       },
//       itemBuilder: (context) => options.map((option) => PopupMenuItem(value: option, child: Text(option))).toList(),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12),
//         child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
//       ),
//     );
//   }
// }
//
