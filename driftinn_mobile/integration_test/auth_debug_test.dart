import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driftinn_mobile/firebase_options.dart';
import 'package:flutter/foundation.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Authentication Flow Diagnostic Test',
      (WidgetTester tester) async {
    // 1. Initialize Firebase
    print('--- TEST: Initializing Firebase ---');
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('--- TEST: Firebase Initialized ---');

    final auth = FirebaseAuth.instance;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final testEmail = 'test_debug_$timestamp@driftinn.test';
    final testPassword = 'Password123!';

    print('--- TEST: TARGET EMAIL: $testEmail ---');

    // 2. Try Registration
    try {
      print('--- TEST: Attempting Registration... ---');
      await auth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      print('--- TEST: Registration SUCCESS! ---');
    } on FirebaseAuthException catch (e) {
      print('--- TEST: REGISTRATION FAILED ---');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('-----------------------------');
      // If registration fails, we can't test login unless we use a known user.
      // But usually if Reg fails, Login fails too (if Key issue).
      if (e.code == 'operation-not-allowed') {
        print('HINT: Enable Email/Password in Firebase Console!');
      }
      return; // Exit test
    } catch (e) {
      print('--- TEST: REGISTRATION FAILED (Generic) ---');
      print('ERROR: $e');
      return;
    }

    // 3. Try Logout
    try {
      await auth.signOut();
      print('--- TEST: Signed Out ---');
    } catch (e) {
      print('--- TEST: SignOut Error: $e ---');
    }

    // 4. Try Login
    try {
      print('--- TEST: Attempting Login... ---');
      await auth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      print('--- TEST: Login SUCCESS! ---');
    } on FirebaseAuthException catch (e) {
      print('--- TEST: LOGIN FAILED ---');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('-----------------------');
    } catch (e) {
      print('--- TEST: LOGIN FAILED (Generic) ---');
      print('ERROR: $e');
    }
  });
}
