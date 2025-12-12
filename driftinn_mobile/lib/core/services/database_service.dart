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
      final doc = await _firestore
          .collection('email_verifications')
          .doc(email)
          .get();

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
}
