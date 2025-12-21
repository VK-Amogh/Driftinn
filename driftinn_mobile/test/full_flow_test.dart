// Full Flow Database Integration Test
// Run with: dart test/full_flow_test.dart
// This tests each step of the user journey against the live Supabase instance.

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  print('===========================================');
  print('   DRIFTINN DATABASE INTEGRATION TEST');
  print('===========================================\n');

  // Initialize Supabase (use your actual keys)
  await Supabase.initialize(
    url: 'https://eivdfakrpxsmxjmdlxaq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpdmRmYWtycHhzbXhqbWRseGFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzODg4ODAsImV4cCI6MjA0ODk2NDg4MH0.jM1pVFRN73yj5R9En-lz-T1qHoHpmSKZ0lnlQ5WvXhI',
  );

  final supabase = Supabase.instance.client;
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

    await supabase.from('users').upsert(userData);

    // Verify
    final fetch =
        await supabase.from('users').select().eq('id', testId).maybeSingle();
    if (fetch != null && fetch['full_name'] == 'Test User') {
      print('   ✅ PASSED: Registration data saved correctly.');
      passed++;
    } else {
      print('   ❌ FAILED: Registration data not found or incorrect.');
      print('   Fetched: $fetch');
      failed++;
    }
  } catch (e) {
    print('   ❌ FAILED: Exception - $e');
    failed++;
  }

  // ===== TEST 2: MBTI Results =====
  print('\n📊 TEST 2: MBTI Result Persistence');
  try {
    // First update onboarding step
    await supabase.from('users').update({
      'onboarding_step': 'alias_creation',
    }).eq('id', testId);

    // Save MBTI result
    final mbtiResult = {
      'user_id': testId,
      'result_data': {
        'mbti_type': 'INTJ',
        'personality_summary': 'The Architect',
        'top_interests': ['Tech', 'Science'],
      },
      'mbti_type': 'INTJ',
      'timestamp': DateTime.now().toIso8601String(),
    };

    await supabase.from('mbti_results').insert(mbtiResult);

    // Verify
    final fetch = await supabase
        .from('mbti_results')
        .select()
        .eq('user_id', testId)
        .maybeSingle();
    if (fetch != null && fetch['mbti_type'] == 'INTJ') {
      print('   ✅ PASSED: MBTI result saved correctly.');
      passed++;
    } else {
      print('   ❌ FAILED: MBTI result not found or incorrect.');
      print('   Fetched: $fetch');
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

    await supabase.from('users').update({
      'alias': alias,
      'username': alias,
      'onboarding_step': 'profile_setup',
    }).eq('id', testId);

    // Verify
    final fetch =
        await supabase.from('users').select().eq('id', testId).single();
    if (fetch['alias'] == alias &&
        fetch['onboarding_step'] == 'profile_setup') {
      print('   ✅ PASSED: Alias saved correctly.');
      passed++;
    } else {
      print('   ❌ FAILED: Alias not saved correctly.');
      print('   Expected alias: $alias, Got: ${fetch['alias']}');
      failed++;
    }
  } catch (e) {
    print('   ❌ FAILED: Exception - $e');
    failed++;
  }

  // ===== TEST 4: Profile Update (Bio) =====
  print('\n📖 TEST 4: Profile Bio Update');
  try {
    await supabase.from('users').update({
      'bio': 'This is a test bio for verification.',
      'onboarding_step': 'completed',
      'registration_completed': true,
    }).eq('id', testId);

    // Verify
    final fetch =
        await supabase.from('users').select().eq('id', testId).single();
    if (fetch['bio'] == 'This is a test bio for verification.' &&
        fetch['registration_completed'] == true) {
      print('   ✅ PASSED: Bio and completion status saved correctly.');
      passed++;
    } else {
      print('   ❌ FAILED: Bio update failed.');
      print('   Fetched: $fetch');
      failed++;
    }
  } catch (e) {
    print('   ❌ FAILED: Exception - $e');
    failed++;
  }

  // ===== TEST 5: Storage Policy Check =====
  print('\n🖼️ TEST 5: Storage Bucket Access');
  try {
    final storage = supabase.storage.from('profile_pic');
    // Just check if the bucket is accessible by listing (may be empty)
    final list = await storage.list(path: '');
    print(
        '   ✅ PASSED: Storage bucket accessible. Found ${list.length} items.');
    passed++;
  } catch (e) {
    print('   ❌ FAILED: Storage access error - $e');
    failed++;
  }

  // ===== CLEANUP (Optional - keep for debugging) =====
  print('\n🧹 Cleanup: Deleting test user...');
  try {
    await supabase.from('mbti_results').delete().eq('user_id', testId);
    await supabase.from('users').delete().eq('id', testId);
    print('   Test data cleaned up.');
  } catch (e) {
    print('   Cleanup failed (non-critical): $e');
  }

  // ===== SUMMARY =====
  print('\n===========================================');
  print('   TEST SUMMARY');
  print('===========================================');
  print('   ✅ Passed: $passed');
  print('   ❌ Failed: $failed');
  print('   Total: ${passed + failed}');
  if (failed == 0) {
    print('\n   🎉 ALL TESTS PASSED! Database is working correctly.');
  } else {
    print('\n   ⚠️ Some tests failed. Check the errors above.');
  }
  print('===========================================\n');
}
