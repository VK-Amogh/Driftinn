import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/features/auth/screens/create_alias_screen.dart';
import 'package:driftinn_mobile/features/auth/screens/login_screen.dart';
import 'package:driftinn_mobile/features/auth/screens/profile_setup_screen.dart';
import 'package:driftinn_mobile/features/home/screens/main_screen.dart';
import 'package:driftinn_mobile/features/mbti/screens/mbti_question_screen.dart';
import 'package:driftinn_mobile/firebase_options.dart';
import 'package:driftinn_mobile/features/auth/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const DriftinnApp());
}

class DriftinnApp extends StatelessWidget {
  const DriftinnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driftinn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/mbti_assessment': (context) => const MbtiQuestionScreen(),
        '/create_alias': (context) => const CreateAliasScreen(),
        '/profile_setup': (context) => const ProfileSetupScreen(),
        '/home': (context) => const MainScreen(),
      },
      initialRoute: '/',
    );
  }
}
