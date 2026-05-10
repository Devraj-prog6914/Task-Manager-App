import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 6));

    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Firebase initialization failed or timed out: $e");
  }

  runApp(const GoogleTasksClone());
}

class GoogleTasksClone extends StatelessWidget {
  const GoogleTasksClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF131416),
      ),
      home: const OnboardingScreen(),
    );
  }
}
