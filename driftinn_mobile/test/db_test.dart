// Standalone Supabase Integration Test (No Flutter Dependencies)
// Run with: dart test/db_test.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

const supabaseUrl = 'https://eivdfakrpxsmxjmdlxaq.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpdmRmYWtycHhzbXhqbWRseGFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzODg4ODAsImV4cCI6MjA0ODk2NDg4MH0.jM1pVFRN73yj5R9En-lz-T1qHoHpmSKZ0lnlQ5WvXhI';

Map<String, String> get headers => {
      'apikey': supabaseKey,
      'Authorization': 'Bearer $supabaseKey',
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    };

Future<void> main() async {
  print('===========================================');
  print('   DRIFTINN DATABASE INTEGRATION TEST');
  print('===========================================\n');

  final testId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
  final testEmail = 'test_$testId@example.com';

  int passed = 0;
  int failed = 0;

  // ===== TEST 1: Registration Data =====
  print('📝 TEST 1: Registration Data Persistence');
  try {
    final userData = {
      'id': testId,
      'email': testEmail,
      'full_name': 'Test User',
      'dob': '2000-01-01',
      'college': 'Test University',
      'grad_year': '2024',
      'study_level': 'Undergraduate',
      'department': 'Computer Science',
      'registration_completed': false,
      'onboarding_step': 'intro',
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Upsert User
    final upsertRes = await http.post(
      Uri.parse('$supabaseUrl/rest/v1/users'),
      headers: {...headers, 'Prefer': 'resolution=merge-duplicates'},
      body: jsonEncode(userData),
    );

    if (upsertRes.statusCode >= 200 && upsertRes.statusCode < 300) {
      // Verify
      final fetchRes = await http.get(
        Uri.parse('$supabaseUrl/rest/v1/users?id=eq.$testId&select=*'),
        headers: headers,
      );
      final fetchData = jsonDecode(fetchRes.body);
      if (fetchData is List &&
          fetchData.isNotEmpty &&
          fetchData[0]['full_name'] == 'Test User') {
        print('   ✅ PASSED: Registration data saved correctly.');
        passed++;
      } else {
        print('   ❌ FAILED: Data verification failed.');
        print('   Response: $fetchData');
        failed++;
      }
    } else {
      print('   ❌ FAILED: Upsert failed with status ${upsertRes.statusCode}');
      print('   Body: ${upsertRes.body}');
      failed++;
    }
  } catch (e) {
    print('   ❌ FAILED: Exception - $e');
    failed++;
  }

  // ===== TEST 2: MBTI Results =====
  print('\n📊 TEST 2: MBTI Result Persistence');
  try {
    // Update onboarding step
    await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/users?id=eq.$testId'),
      headers: headers,
      body: jsonEncode({'onboarding_step': 'alias_creation'}),
    );

    // Insert MBTI result
    final mbtiResult = {
      'user_id': testId,
      'result_data': {
        'mbti_type': 'INTJ',
        'personality_summary': 'The Architect'
      },
      'mbti_type': 'INTJ',
      'timestamp': DateTime.now().toIso8601String(),
    };

    final insertRes = await http.post(
      Uri.parse('$supabaseUrl/rest/v1/mbti_results'),
      headers: headers,
      body: jsonEncode(mbtiResult),
    );

    if (insertRes.statusCode >= 200 && insertRes.statusCode < 300) {
      // Verify
      final fetchRes = await http.get(
        Uri.parse(
            '$supabaseUrl/rest/v1/mbti_results?user_id=eq.$testId&select=*'),
        headers: headers,
      );
      final fetchData = jsonDecode(fetchRes.body);
      if (fetchData is List &&
          fetchData.isNotEmpty &&
          fetchData[0]['mbti_type'] == 'INTJ') {
        print('   ✅ PASSED: MBTI result saved correctly.');
        passed++;
      } else {
        print('   ❌ FAILED: MBTI verification failed.');
        print('   Response: $fetchData');
        failed++;
      }
    } else {
      print('   ❌ FAILED: Insert failed with status ${insertRes.statusCode}');
      print('   Body: ${insertRes.body}');
      failed++;
    }
  } catch (e) {
    print('   ❌ FAILED: Exception - $e');
    failed++;
  }

  // ===== TEST 3: Alias Creation =====
  print('\n🎭 TEST 3: Alias Creation');
  try {
    final alias = 'TestAlias${DateTime.now().millisecondsSinceEpoch % 10000}';

    final updateRes = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/users?id=eq.$testId'),
      headers: headers,
      body: jsonEncode({
        'alias': alias,
        'username': alias,
        'onboarding_step': 'profile_setup',
      }),
    );

    if (updateRes.statusCode >= 200 && updateRes.statusCode < 300) {
      // Verify
      final fetchRes = await http.get(
        Uri.parse(
            '$supabaseUrl/rest/v1/users?id=eq.$testId&select=alias,onboarding_step'),
        headers: headers,
      );
      final fetchData = jsonDecode(fetchRes.body);
      if (fetchData is List &&
          fetchData.isNotEmpty &&
          fetchData[0]['alias'] == alias) {
        print('   ✅ PASSED: Alias saved correctly.');
        passed++;
      } else {
        print('   ❌ FAILED: Alias verification failed.');
        failed++;
      }
    } else {
      print('   ❌ FAILED: Update failed with status ${updateRes.statusCode}');
      print('   Body: ${updateRes.body}');
      failed++;
    }
  } catch (e) {
    print('   ❌ FAILED: Exception - $e');
    failed++;
  }

  // ===== TEST 4: Profile Update (Bio) =====
  print('\n📖 TEST 4: Profile Bio Update');
  try {
    final updateRes = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/users?id=eq.$testId'),
      headers: headers,
      body: jsonEncode({
        'bio': 'This is a test bio.',
        'onboarding_step': 'completed',
        'registration_completed': true,
      }),
    );

    if (updateRes.statusCode >= 200 && updateRes.statusCode < 300) {
      // Verify
      final fetchRes = await http.get(
        Uri.parse(
            '$supabaseUrl/rest/v1/users?id=eq.$testId&select=bio,registration_completed'),
        headers: headers,
      );
      final fetchData = jsonDecode(fetchRes.body);
      if (fetchData is List &&
          fetchData.isNotEmpty &&
          fetchData[0]['bio'] == 'This is a test bio.' &&
          fetchData[0]['registration_completed'] == true) {
        print('   ✅ PASSED: Bio and completion status saved correctly.');
        passed++;
      } else {
        print('   ❌ FAILED: Profile verification failed.');
        print('   Response: $fetchData');
        failed++;
      }
    } else {
      print('   ❌ FAILED: Update failed with status ${updateRes.statusCode}');
      failed++;
    }
  } catch (e) {
    print('   ❌ FAILED: Exception - $e');
    failed++;
  }

  // ===== CLEANUP =====
  print('\n🧹 Cleanup: Deleting test data...');
  try {
    await http.delete(
      Uri.parse('$supabaseUrl/rest/v1/mbti_results?user_id=eq.$testId'),
      headers: headers,
    );
    await http.delete(
      Uri.parse('$supabaseUrl/rest/v1/users?id=eq.$testId'),
      headers: headers,
    );
    print('   Test data cleaned up.');
  } catch (e) {
    print('   Cleanup failed (non-critical): $e');
  }

  // ===== SUMMARY =====
  print('\n===========================================');
  print('   TEST SUMMARY');
  print('===========================================');
  print('   ✅ Passed: $passed / 4');
  print('   ❌ Failed: $failed / 4');
  if (failed == 0) {
    print('\n   🎉 ALL TESTS PASSED! Database is working correctly.');
  } else {
    print('\n   ⚠️ Some tests failed. Check the errors above.');
  }
  print('===========================================\n');
}
