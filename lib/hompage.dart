import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String result = "";
  bool isLoading = false;
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    loadDataModelFiles();
  }

  loadDataModelFiles() async {
    try {
      String? output = await Tflite.loadModel(
        model: "assets/models/model_unquant.tflite",
        labels: "assets/models/labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false,
      );
      print(output);
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  doImageClassification() async {
    if (_image == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      var recognition = await Tflite.runModelOnImage(
        path: _image!.path,
        imageMean: 127.5, // Adjust as per your model's requirement
        imageStd: 127.5,  // Adjust as per your model's requirement
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      if (recognition != null && recognition.isNotEmpty) {
        setState(() {
          result = recognition.map((e) => e["label"]).join(', ');
        });
      }
    } catch (e) {
      print("Error during classification: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  selectPhoto() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doImageClassification();
      });
    }
  }

  capturePhoto() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doImageClassification();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayResult = result.isNotEmpty && result.length > 1 ? result.substring(1) : result;

    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: selectPhoto,
                  onLongPress: capturePhoto,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(
                            width: 140,
                            height: 190,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 200),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: Text(
                      displayResult, // Use modified result for display
                      textAlign: TextAlign.center,
                      style: GoogleFonts.langar(
                        fontSize: 35,
                        color: Colors.blueAccent,
                        backgroundColor: Colors.white60,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
