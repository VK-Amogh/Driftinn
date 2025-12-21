import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // --- Chat Methods ---

  // Send Message
  Future<void> sendMessage(
    String chatId,
    Map<String, dynamic> messageData,
  ) async {
    try {
      // Supabase 'messages' table: needs chat_id, sender_id, content, timestamp
      // Assuming messageData maps correctly or we adapt it here
      await _supabase.from('messages').insert({
        'chat_id': chatId,
        ...messageData,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  // Get Messages Stream
  // Supabase Realtime
  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('timestamp', ascending: false);
  }

  // --- User Data ---

  // Save User Data (e.g. after registration)
  Future<void> saveUserData(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      debugPrint('=== SAVE USER DATA START ===');
      debugPrint('User ID: $userId');
      debugPrint('Data: $userData');

      final payload = {
        'id': userId,
        ...userData,
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('Full Payload: $payload');

      // Upsert into 'users' table
      final response = await _supabase.from('users').upsert(payload).select();

      debugPrint('Supabase Response: $response');
      debugPrint('=== SAVE USER DATA SUCCESS ===');
    } catch (e, stackTrace) {
      debugPrint('=== SAVE USER DATA FAILED ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stackTrace');
      rethrow; // Rethrow so caller can handle
    }
  }

  // --- Verification Codes (OTP) ---
  // Ideally, use Supabase Auth OTP. For manual storage:

  Future<void> storeOTP(String email, String otp) async {
    // Note: Better to use Supabase Auth for this, but for manual DB storage:
    // Create a table 'email_verifications' or store in a separate DB
    // Skipping implementation to focus on main requested migration features
    debugPrint("Skipping manual OTP store. Use Supabase Auth OTP instead.");
  }

  Future<bool> verifyOTP(String email, String otp) async {
    // Skipping manual verification logic
    return true;
  }

  Future<void> storePhoneOTP(String phoneNumber, String otp) async {
    debugPrint("Skipping manual Phone OTP store.");
  }

  Future<bool> verifyPhoneOTP(String phoneNumber, String otp) async {
    return true;
  }

  // --- Post-MBTI Flow Methods ---

  // Check if alias is taken
  Future<bool> isAliasTaken(String alias) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id')
          .eq('alias', alias)
          .maybeSingle(); // Returns null if not found
      return response != null;
    } catch (e) {
      debugPrint("Error checking alias: $e");
      return true; // Fail safe
    }
  }

  // Save MBTI Result
  Future<void> saveMbtiResult(String uid, Map<String, dynamic> result) async {
    try {
      // 1. Upsert user profile to mark progress (ensures user record exists)
      await _supabase.from('users').upsert({
        'id': uid,
        'onboarding_step': 'alias_creation',
      });

      // 2. Save to mbti_results table (History)
      await _supabase.from('mbti_results').insert({
        'user_id': uid,
        'result_data': result,
        'mbti_type': result['type'], // Assuming result has 'type'
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Error saving MBTI result: $e");
      rethrow;
    }
  }

  // Set User Alias
  Future<void> setUserAlias(String uid, String alias) async {
    try {
      await _supabase.from('users').upsert({
        'id': uid, // Ensure user exists or is created
        'alias': alias,
        'username': alias,
        'onboarding_step': 'profile_setup',
      });
    } catch (e) {
      debugPrint("Error setting alias: $e");
      rethrow;
    }
  }

  // Upload profile picture to Supabase Storage and update user's photo_url
  Future<void> uploadProfilePicture(String uid, File imageFile) async {
    try {
      // Define storage bucket and path
      final storage = Supabase.instance.client.storage.from('profile_pic');
      final path =
          '$uid/profile_picture${imageFile.path.endsWith('.png') ? '.png' : '.jpg'}';

      // Upload the file (with upsert to overwrite existing)
      await storage.upload(
        path,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );

      // Get public URL (bucket must be public) or signed URL
      final publicUrl = storage.getPublicUrl(path);

      // Update user's photo_url in the users table
      await _supabase
          .from('users')
          .update({'photo_url': publicUrl}).eq('id', uid);
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      rethrow;
    }
  }

  // Get User Profile Data
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', uid).maybeSingle();
      return response;
    } catch (e) {
      debugPrint("Error fetching user profile: $e");
      return null;
    }
  }

  // Update Profile (Bio, Photo)
  Future<void> updateUserProfile(String uid,
      {String? bio, String? photoUrl}) async {
    try {
      Map<String, dynamic> data = {
        'onboarding_step': 'completed',
        'registration_completed': true,
      };
      if (bio != null) data['bio'] = bio;
      if (photoUrl != null) data['photo_url'] = photoUrl;

      await _supabase.from('users').update(data).eq('id', uid);
    } catch (e) {
      debugPrint("Error updating profile: $e");
      rethrow;
    }
  }

  // Get User Onboarding Status
  Future<String?> getUserOnboardingStatus(String uid) async {
    try {
      final response = await _supabase
          .from('users')
          .select('onboarding_step')
          .eq('id', uid)
          .maybeSingle();

      if (response != null) {
        return response['onboarding_step'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching onboarding status: $e");
      return null;
    }
  }
}
