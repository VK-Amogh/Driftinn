import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    functions: FirebaseFunctions.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  }) : _auth = auth,
       _firestore = firestore,
       _functions = functions;

  Future<void> signInWithPhone({
    required String phoneNumber,
    required Function(String, int?) codeSent,
    required Function(FirebaseAuthException) verificationFailed,
  }) async {
    final bool useRest =
        defaultTargetPlatform == TargetPlatform.windows && kDebugMode;

    if (useRest) {
      try {
        // REST call to Auth Emulator to send code
        // http://localhost:9105/identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=fake-api-key
        final url = Uri.parse(
          'http://127.0.0.1:9105/identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=fake_api_key_for_emulators',
        );
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phoneNumber': phoneNumber}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final verificationId = data['sessionInfo'];
          // Determine if it was instant verification (usually not for phone)
          codeSent(verificationId, null);
        } else {
          throw FirebaseAuthException(
            code: 'rest-error',
            message: "AuthREST Failed: ${response.statusCode} ${response.body}",
          );
        }
      } catch (e) {
        verificationFailed(
          FirebaseAuthException(code: 'error', message: e.toString()),
        );
      }
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    final bool useRest =
        defaultTargetPlatform == TargetPlatform.windows && kDebugMode;

    if (useRest) {
      // REST call to verify code
      final url = Uri.parse(
        'http://127.0.0.1:9105/identitytoolkit.googleapis.com/v1/accounts:signInWithPhoneNumber?key=fake_api_key_for_emulators',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sessionInfo': verificationId, 'code': smsCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Returns { idToken, refreshToken, localId, phoneNumber, ... }
        debugPrint("OTP Verified via REST: ${response.body}");
        return data;
      } else {
        throw FirebaseAuthException(
          code: 'rest-error',
          message: "VerifyREST Failed: ${response.statusCode} ${response.body}",
        );
      }
    } else {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return {'localId': userCredential.user?.uid, 'idToken': 'native-token'};
    }
  }

  Future<bool> checkUserExists(String uid) async {
    try {
      final bool useRest =
          defaultTargetPlatform == TargetPlatform.windows && kDebugMode;

      if (useRest) {
        final url = Uri.parse(
          'http://127.0.0.1:5005/driftinn/us-central1/accountCheck',
        );
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'data': {'uid': uid},
          }),
        );
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final result = json['result'] ?? json['data'];
          return result['exists'] == true;
        }
        return false;
      } else {
        final callable = _functions.httpsCallable('accountCheck');
        final result = await callable.call({'uid': uid});
        return result.data['exists'] == true;
      }
    } catch (e) {
      debugPrint("Account Check Error: $e");
      return false; // Default to new user on error
    }
  }

  Future<void> verifyCollegeDomain({required String email}) async {
    try {
      final bool useRest =
          defaultTargetPlatform == TargetPlatform.windows && kDebugMode;

      if (useRest) {
        // Direct REST call to Emulator (Bypassing Windows SDK channel issues)
        final url = Uri.parse(
          'http://127.0.0.1:5005/driftinn/us-central1/verifyCollegeDomain',
        );
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'data': {'email': email},
          }),
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          // Result is wrapped in 'result'
          final data = json['result'];
          if (data['valid'] != true) {
            throw Exception(data['message'] ?? "Invalid college domain.");
          }
        } else {
          throw Exception(
            "Function failed: ${response.statusCode} - ${response.body}",
          );
        }
      } else {
        // Standard SDK call
        final callable = _functions.httpsCallable('verifyCollegeDomain');
        final result = await callable.call({'email': email});
        if (result.data['valid'] != true) {
          throw Exception("Invalid college domain.");
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
