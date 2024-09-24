import 'package:cat_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for locking orientation

void main() {
  // Lock the orientation to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cat Breed Identifier",
      debugShowCheckedModeBanner: false,
      home: MySplash(),
    );
  }
}
