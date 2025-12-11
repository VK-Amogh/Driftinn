import 'package:driftinn/features/auth/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    // Try default init
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Default Firebase init failed: $e");

    // Fallback for Windows/Local checks without valid credentials file.
    if (defaultTargetPlatform == TargetPlatform.windows || kDebugMode) {
      debugPrint("Attempting fallback init for Emulators...");
      try {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "fake_api_key_for_emulators",
            appId: "fake_app_id",
            messagingSenderId: "fake_sender_id",
            projectId: "driftinn",
          ),
        );
      } catch (e2) {
        debugPrint("Fallback init also failed: $e2");
      }
    }
  }

  // Connect to Emulators if in Debug Mode
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8085);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9105);
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5005);
      debugPrint('Connected to Firebase Emulators');
    } catch (e) {
      debugPrint('Failed to connect to emulators: $e');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driftinn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA855F7),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),
    );
  }
}
