import 'package:driftinn/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driftinn/features/auth/screens/otp_screen.dart'; // Import this
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = NotifierProvider<AuthController, bool>(
  AuthController.new,
);

class AuthController extends Notifier<bool> {
  late final AuthRepository _authRepository;

  @override
  bool build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return false; // Initial state: not loading
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    state = true;
    _authRepository.signInWithPhone(
      phoneNumber: phoneNumber,
      codeSent: (String verificationId, int? resendToken) {
        state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Sent! Check Terminal for code.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification Failed')),
        );
      },
    );
  }

  void verifyOTP(
    BuildContext context,
    String verificationId,
    String smsCode,
  ) async {
    state = true;
    try {
      final authData = await _authRepository.verifyOTP(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final uid = authData['localId'];

      if (uid != null) {
        final exists = await _authRepository.checkUserExists(uid);
        state = false;

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phone Verified! User Exists: $exists')),
          );

          if (exists) {
            // Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Navigator.pushReplacementNamed(context, '/onboarding');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Redirecting to Onboarding...')),
            );
          }
        }
      } else {
        throw Exception("No UID returned");
      }
    } catch (e) {
      state = false;
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<bool> verifyCollegeEmail(BuildContext context, String email) async {
    state = true;
    try {
      await _authRepository.verifyCollegeDomain(email: email);
      state = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification sent to email')),
        );
      }
      return true; // Success
    } catch (e) {
      state = false;
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      return false; // Failure
    }
  }
}
