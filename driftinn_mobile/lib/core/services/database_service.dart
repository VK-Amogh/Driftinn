import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'driftinn-db',
  );

  // Send Message
  Future<void> sendMessage(
    String chatId,
    Map<String, dynamic> messageData,
  ) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Get Messages Stream
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Save User Data (e.g. after registration)
  Future<void> saveUserData(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Store OTP
  Future<void> storeOTP(String email, String otp) async {
    try {
      await _firestore.collection('email_verifications').doc(email).set({
        'otp': otp,
        'timestamp': FieldValue.serverTimestamp(),
        'verified': false,
      });
      debugPrint('OTP stored for $email: $otp');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Verify OTP
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final doc =
          await _firestore.collection('email_verifications').doc(email).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final serverOtp = data['otp'];
        // Optional: Check timestamp for expiration

        if (serverOtp == otp) {
          // Mark as verified
          await _firestore.collection('email_verifications').doc(email).update({
            'verified': true,
          });
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Store Phone OTP
  Future<void> storePhoneOTP(String phoneNumber, String otp) async {
    try {
      await _firestore.collection('phone_verifications').doc(phoneNumber).set({
        'otp': otp,
        'timestamp': FieldValue.serverTimestamp(),
        'verified': false,
      });
      debugPrint('OTP stored for $phoneNumber: $otp');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Verify Phone OTP
  Future<bool> verifyPhoneOTP(String phoneNumber, String otp) async {
    try {
      final doc = await _firestore
          .collection('phone_verifications')
          .doc(phoneNumber)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final serverOtp = data['otp'];
        // Optional: Check timestamp for expiration

        if (serverOtp == otp) {
          // Mark as verified
          await _firestore
              .collection('phone_verifications')
              .doc(phoneNumber)
              .update({'verified': true});
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
  // --- Post-MBTI Flow Methods ---

  // Check if alias is taken (Case-insensitive check recommended, but simple query for now)
  Future<bool> isAliasTaken(String alias) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('alias', isEqualTo: alias)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      debugPrint("Error checking alias: $e");
      return true; // Fallback to "taken" on error to prevent duplicates
    }
  }

  // Save MBTI Result
  Future<void> saveMbtiResult(String uid, Map<String, dynamic> result) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'mbtiResult': result,
        'mbtiTimestamp': FieldValue.serverTimestamp(),
        'onboardingStep': 'alias_creation', // Track progress
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saving MBTI result: $e");
      rethrow;
    }
  }

  // Set User Alias
  Future<void> setUserAlias(String uid, String alias) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'alias': alias,
        'username': alias, // Keeping both for compatibility if needed
        'onboardingStep': 'profile_setup',
      });
    } catch (e) {
      debugPrint("Error setting alias: $e");
      rethrow;
    }
  }

  // Update Profile (Bio, Photo)
  Future<void> updateUserProfile(String uid,
      {String? bio, String? photoUrl}) async {
    try {
      Map<String, dynamic> data = {
        'onboardingStep': 'completed',
        'registrationCompleted': true,
      };
      if (bio != null) data['bio'] = bio;
      if (photoUrl != null) data['photoUrl'] = photoUrl;

      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      debugPrint("Error updating profile: $e");
      rethrow;
    }
  }

  // Get User Onboarding Status
  Future<String?> getUserOnboardingStatus(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['onboardingStep'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching onboarding status: $e");
      return null;
    }
  }
}
