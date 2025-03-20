// import 'dart:io';
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'wbcdetect2_model.dart';
// import 'dart:typed_data';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: const InferenceScreen(),
//     );
//   }
// }
//
// class InferenceScreen extends StatefulWidget {
//   const InferenceScreen({super.key});
//
//   @override
//   State<InferenceScreen> createState() => _InferenceScreenState();
// }
//
// class _InferenceScreenState extends State<InferenceScreen> {
//   List<File> inputImages = [];
//   List<Map<String, dynamic>> results = [];
//   bool isProcessing = false;
//
//   // Select Folder
//   Future<void> pickFolder() async {
//     String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
//     if (selectedDirectory != null) {
//       Directory dir = Directory(selectedDirectory);
//       List<File> images = dir
//           .listSync()
//           .where((file) => file.path.endsWith('.jpg') || file.path.endsWith('.png'))
//           .map((file) => File(file.path))
//           .toList();
//
//       setState(() {
//         inputImages = images;
//         results = [];
//       });
//     }
//   }
//
//   // Run inference on each image
//   Future<void> runInference() async {
//     if (inputImages.isEmpty) {
//       return;
//     }
//
//     setState(() {
//       isProcessing = true;
//       results = [];
//     });
//
//     for (File image in inputImages) {
//       try {
//         Map<String, dynamic> responseData = await _processImage(image);
//
//         // Extract detections
//         List<Map<String, dynamic>> detections = (responseData["classification_predictions"] as List)
//             .map<Map<String, dynamic>>((d) => {
//           "class": d["top"],
//           "confidence": "${(d["confidence"] * 100).toStringAsFixed(2)}%"
//         })
//             .toList();
//
//         // Extract output image
//         Uint8List? outputImage;
//         if (responseData.containsKey("output_image")) {
//           outputImage = base64Decode(responseData["output_image"]);
//         }
//
//         // Store results
//         results.add({
//           "input_image": image.path,
//           "output_image": outputImage,
//           "detections": detections,
//         });
//       } catch (e) {
//         print("❌ Error processing ${image.path}: $e");
//       }
//     }
//
//     setState(() {
//       isProcessing = false;
//     });
//   }
//
//   Future<Map<String, dynamic>> _processImage(File image) async {
//     WBCDetect2Model model = WBCDetect2Model();
//     return await model.runInference(image);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: AppBar(
//         title: const Text("WBC Image Classification"),
//         actions: [
//           ElevatedButton(onPressed: pickFolder, child: const Text("Upload Folder")),
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: isProcessing ? null : runInference,
//             child: isProcessing
//                 ? const CircularProgressIndicator(color: Colors.white)
//                 : const Text("Run Inference"),
//           ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       body: results.isEmpty
//           ? const Center(
//         child: Text(
//           "Upload and process images to see results",
//           style: TextStyle(color: Colors.white54, fontSize: 18),
//         ),
//       )
//           : Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: GridView.builder(
//           itemCount: results.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // Show 2 images per row
//             childAspectRatio: 1.2,
//           ),
//           itemBuilder: (context, index) {
//             var result = results[index];
//             return Card(
//               color: Colors.grey[900],
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Input Image
//                   Expanded(
//                     child: Image.file(File(result["input_image"]), fit: BoxFit.cover),
//                   ),
//                   const SizedBox(height: 5),
//                   const Text(
//                     "Input Image",
//                     style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
//                   ),
//                   const Divider(color: Colors.white24),
//
//                   // Output Image
//                   result["output_image"] != null
//                       ? Expanded(
//                     child: Image.memory(result["output_image"], fit: BoxFit.cover),
//                   )
//                       : const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text("No Output Image",
//                         style: TextStyle(color: Colors.white54)),
//                   ),
//
//                   const Text(
//                     "Output Image",
//                     style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
//                   ),
//                   const Divider(color: Colors.white24),
//
//                   // Class and Confidence
//                   Column(
//                     children: result["detections"].map<Widget>((detection) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
//                         child: Text(
//                           "${detection["class"]}: ${detection["confidence"]}",
//                           style: const TextStyle(color: Colors.white54),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

//
// import 'dart:io';
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'wbcdetect2_model.dart';
// import 'model2.dart';
// import 'model3.dart';
// import 'dart:typed_data';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: const InferenceScreen(),
//     );
//   }
// }
//
// class InferenceScreen extends StatefulWidget {
//   const InferenceScreen({super.key});
//
//   @override
//   State<InferenceScreen> createState() => _InferenceScreenState();
// }
//
// class _InferenceScreenState extends State<InferenceScreen> {
//   String selectedModel = 'WBC Detection';
//   final List<String> availableModels = ['WBC Detection', 'Model2', 'Model3'];
//
//   File? inputImage;
//   Uint8List? outputImage;
//   bool isLoading = false;
//   List<Map<String, dynamic>> detections = [];
//
//   // Select Image
//   Future<void> pickImage() async {
//     final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (pickedFile != null) {
//       setState(() {
//         inputImage = File(pickedFile.files.single.path!);
//         outputImage = null;
//         detections = [];
//       });
//     }
//   }
//
//   // Run Inference
//   Future<void> runInference() async {
//     if (inputImage == null) {
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       detections = [];
//       outputImage = null;
//     });
//
//     try {
//       Map<String, dynamic> responseData = {};
//
//       if (selectedModel == 'WBC Detection') {
//         WBCDetect2Model model = WBCDetect2Model();
//         responseData = await model.runInference(inputImage!);
//       } else if (selectedModel == 'Model2') {
//         Model2 model = Model2();
//         responseData = await model.runInference(inputImage!);
//       } else if (selectedModel == 'Model3') {
//         Model3 model = Model3();
//         responseData = await model.runInference(inputImage!);
//       }
//
//       if (responseData.isNotEmpty) {
//         setState(() {
//           detections = (responseData["classification_predictions"] as List)
//               .map<Map<String, dynamic>>((d) => {
//             "class": d["top"],
//             "confidence": "${(d["confidence"] * 100).toStringAsFixed(2)}%"
//           })
//               .toList();
//
//           if (responseData.containsKey("output_image")) {
//             outputImage = base64Decode(responseData["output_image"]);
//           }
//         });
//       }
//     } catch (e) {
//       setState(() {
//         detections = [];
//       });
//       print("Error in inference: $e");
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
//           // Top Menu Bar
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               border: const Border(bottom: BorderSide(color: Colors.white, width: 1)),
//             ),
//             child: Row(
//               children: [
//                 _buildMenuButton("File", ["Open", "New", "Exit"]),
//                 _buildMenuButton("Help", ["Documentation", "About"]),
//               ],
//             ),
//           ),
//           // Main Content Area
//           Expanded(
//             child: Row(
//               children: [
//                 // Sidebar Controls
//                 Container(
//                   width: 250,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[900],
//                     border: const Border(right: BorderSide(color: Colors.white24)),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Upload Single Image Button (Outlined)
//                       SizedBox(
//                         width: 260,
//                         child: OutlinedButton.icon(
//                           onPressed: pickImage,
//                           icon: const Icon(Icons.upload_file, color: Colors.white),
//                           label: const Text(
//                             "Upload Single Image",
//                             style: TextStyle(fontSize: 13, color: Colors.white),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             side: const BorderSide(color: Colors.white, width: 0.2),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Upload Folder Button (Outlined)
//                       SizedBox(
//                         width: 260,
//                         child: OutlinedButton.icon(
//                           onPressed: pickImage,
//                           icon: const Icon(Icons.folder_open, color: Colors.white),
//                           label: const Text(
//                             "Upload Folder",
//                             style: TextStyle(fontSize: 13, color: Colors.white),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             side: const BorderSide(color: Colors.white, width: 0.2),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20), // Bigger gap before inference buttons
//
//                       // Run Inference (Single) Button
//                       SizedBox(
//                         width: 260,
//                         child: ElevatedButton.icon(
//                           onPressed: runInference,
//                           icon: const Icon(Icons.play_arrow, color: Colors.black),
//                           label: isLoading
//                               ? const CircularProgressIndicator(color: Colors.black45)
//                               : const Text(
//                             "Run Inference (Single)",
//                             style: TextStyle(fontSize: 13, color: Colors.black),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white, // White filled button
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Run Inference (Batch) Button
//                       SizedBox(
//                         width: 260,
//                         child: ElevatedButton.icon(
//                           onPressed: runInference,
//                           icon: const Icon(Icons.play_circle, color: Colors.black),
//                           label: isLoading
//                               ? const CircularProgressIndicator(color: Colors.black45)
//                               : const Text(
//                             "Run Inference (Batch)",
//                             style: TextStyle(fontSize: 13, color: Colors.black),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white, // White filled button
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//
//                       // Dropdown Label
//                       // const Text(
//                       //   "Select Model",
//                       //   style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
//                       // ),
//                       const SizedBox(height: 8),
//
//                       // Dropdown for Model Selection
//                       DropdownButton<String>(
//                         value: selectedModel,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedModel = newValue!;
//                           });
//                         },
//                         items: availableModels
//                             .map<DropdownMenuItem<String>>(
//                                 (String model) => DropdownMenuItem<String>(
//                               value: model,
//                               child: Text(model),
//                             ))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Image Display Panel
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Row(
//                           children: [
//                             // Input Image Panel
//                             Expanded(
//                               child: Container(
//                                 margin: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.white24),
//                                 ),
//                                 child: Center(
//                                   child: inputImage != null
//                                       ? Image.file(inputImage!)
//                                       : const Text("Upload an Image",
//                                       style: TextStyle(color: Colors.white)),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: outputImage != null
//                                   ? Container(
//                                 margin: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.white24),
//                                 ),
//                                 child: Center(
//                                     child:  Image.memory(outputImage!)
//
//                                 ),
//                               ) : const Text("",
//                                   style: TextStyle(color: Colors.white)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Bottom Panel: Display Inference Result
//                       SingleChildScrollView(
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           width: double.infinity,
//                           height: 200,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[850],
//                             border: const Border(top: BorderSide(color: Colors.white24)),
//                           ),
//                           child: detections.isNotEmpty
//                               ? SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text("Detected Classes:",
//                                     style: TextStyle(color: Colors.white, fontSize: 16)),
//                                 ...detections.map((detection) => Text(
//                                   "${detection["class"]}: ${detection["confidence"]}",
//                                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                                 ))
//                               ],
//                             ),
//                           )
//                               : const Text("Inference results will be displayed here.",
//                               style: TextStyle(color: Colors.white54)),
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
//               outputImage = null;
//               detections = [];
//             });
//           } else if (value == "Exit") {
//             exit(0);
//           }
//         }
//       },
//       itemBuilder: (context) =>
//           options.map((option) => PopupMenuItem(value: option, child: Text(option))).toList(),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
//       ),
//     );
//   }
// }

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
  bool isLoading1 = false;
  bool isLoading2 = false;
  List<Map<String, dynamic>> detections = [];

  List<File> inputImages = [];
  List<Map<String, dynamic>> results = [];
  bool isBatchMode = false;
  int selectedImageIndex = 0;

  // Pick Single Image
  Future<void> pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedFile != null) {
      setState(() {
        isBatchMode = false;
        inputImage = File(pickedFile.files.single.path!);
        outputImage = null;
        detections = [];
      });
      // await runInference();
    }
  }

  // Pick Folder and Run Batch Inference
  Future<void> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      Directory dir = Directory(selectedDirectory);
      List<File> images = dir
          .listSync()
          .where((file) => file.path.endsWith('.jpg') || file.path.endsWith('.png'))
          .map((file) => File(file.path))
          .toList();

      setState(() {
        isBatchMode = true;
        inputImages = images;
        results = [];
        selectedImageIndex = 0;
      });

      // await runBatchInference();
    }
  }

  // Run Inference for Single Image
  Future<void> runInference() async {
    if (inputImage == null) return;

    setState(() {
      isLoading1 = true;
      detections = [];
      outputImage = null;
    });

    try {
      Map<String, dynamic> responseData = await processImage(inputImage!);

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
      print("Error in inference: $e");
    } finally {
      setState(() {
        isLoading1 = false;
      });
    }
  }

  // Run Batch Inference
  Future<void> runBatchInference() async {
    if (inputImages.isEmpty) return;

    setState(() {
      isLoading2 = true;
      results = [];
    });

    for (File image in inputImages) {
      try {
        Map<String, dynamic> responseData = await processImage(image);

        Uint8List? output;
        if (responseData.containsKey("output_image")) {
          output = base64Decode(responseData["output_image"]);
        }

        results.add({
          "input_image": image.path,
          "output_image": output,
          "detections": responseData["classification_predictions"],
        });
      } catch (e) {
        print("Error processing ${image.path}: $e");
      }
    }

    setState(() {
      isLoading2 = false;
    });
  }

  Future<Map<String, dynamic>> processImage(File image) async {
    if (selectedModel == 'WBC Detection') {
      return await WBCDetect2Model().runInference(image);
    } else if (selectedModel == 'Model2') {
      return await Model2().runInference(image);
    } else {
      return await Model3().runInference(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          // Header
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
                // Left Sidebar Controls
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
                      // Upload Single Image Button (Outlined)
                      SizedBox(
                        width: 260,
                        child: OutlinedButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(Icons.upload_file, color: Colors.white),
                          label: const Text(
                            "Upload Single Image",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.white, width: 0.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Upload Folder Button (Outlined)
                      SizedBox(
                        width: 260,
                        child: OutlinedButton.icon(
                          onPressed: pickFolder,
                          icon: const Icon(Icons.folder_open, color: Colors.white),
                          label: const Text(
                            "Upload Folder",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.white, width: 0.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Bigger gap before inference buttons

                      isBatchMode ?
                      // Run Inference (Single) Button
                      SizedBox(
                        width: 260,
                        child: ElevatedButton.icon(
                          onPressed: runBatchInference,
                          icon: const Icon(Icons.play_circle, color: Colors.black),
                          label: isLoading2
                              ? const CircularProgressIndicator(color: Colors.black45)
                              : const Text(
                            "Run Inference (Batch)",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White filled button
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ):SizedBox(
                        width: 260,
                        child: ElevatedButton.icon(
                          onPressed: runInference,
                          icon: const Icon(Icons.play_arrow, color: Colors.black),
                          label: isLoading1
                              ? const CircularProgressIndicator(color: Colors.black45)
                              : const Text(
                            "Run Inference",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White filled button
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      )

                      // Run Inference (Batch) Button
                      ,
                      const SizedBox(height: 40),

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
                          ),
                        )
                            .toList(),
                      ),
                    ],
                  ),
                ),

                // Right Section for Input, Output, and Inference Result
                Expanded(
                  child: Column(
                    children: [
                      // Top Panel: Input and Output Images
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            // Left: Input Image(s)
                            Container(
                              width: 400,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: isBatchMode
                                  ? GridView.builder(
                                itemCount: inputImages.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemBuilder: (context, index) => GestureDetector(
                                  onTap: () => setState(() {
                                    selectedImageIndex = index;
                                  }),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3), // Adjust the radius as per your need
                                    child: Image.file(
                                      inputImages[index],
                                      fit: BoxFit.cover, // Ensures the image fills the container
                                    ),
                                  ),
                                ),
                              )
                                  : inputImage != null
                                  ? Image.file(inputImage!)
                                  : const Center(child: Text("Upload an Image", style: TextStyle(color: Colors.white))),
                            ),

                            // Right: Output Image
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: isBatchMode
                                    ? results.isNotEmpty
                                    ? results[selectedImageIndex]["output_image"] != null
                                    ? Image.memory(results[selectedImageIndex]["output_image"], fit: BoxFit.fitHeight)
                                    : const Text("No Output", style: TextStyle(color: Colors.white))
                                    : (isLoading1 || isLoading2) ? const Center(child: Text("Processing...", style: TextStyle(color: Colors.white))) : const Center(child:  Text("Please run interference", style: TextStyle(color: Colors.white)))
                                    : outputImage != null
                                    ? Image.memory(outputImage!, fit: BoxFit.fitHeight)
                                    : const Center( child: Text("Inference output", style: TextStyle(color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Panel: Display Inference Result
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),

                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            border: const Border(top: BorderSide(color: Colors.white24)),
                          ),
                          child: isBatchMode
                              ? ListView.builder(

                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              var result = results[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...result["detections"].map<Widget>((detection) {
                                    return Text(
                                      "${detection["predictions"][0]["class"]}: ${detection["confidence"]}",
                                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                                    );
                                  }).toList(),
                                  const Divider(color: Colors.white24),
                                ],
                              );
                            },
                          )
                              : detections.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: detections.map<Widget>((detection) {
                              return Text(
                                "${detection["class"]}: ${detection["confidence"]}",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              );
                            }).toList(),
                          )
                              : const Text("Inference results will be displayed here.", style: TextStyle(color: Colors.white54)),
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
              inputImages = [];
              isBatchMode = false;
              results = [];
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




