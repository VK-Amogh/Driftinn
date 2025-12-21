import 'dart:convert';
import 'package:driftinn_mobile/core/services/offline_question_bank.dart';

void main() {
  final allQuestions = [
    ...OfflineQuestionBank.personalityQuestions,
    ...OfflineQuestionBank.interestQuestions
  ];

  print(
      "insert into public.mbti_questions (question, subtitle, dimension, options) values");

  for (int i = 0; i < allQuestions.length; i++) {
    final q = allQuestions[i];
    final optionsJson = jsonEncode(q['options']);
    // Escape single quotes in options
    final escapedOptions = optionsJson.replaceAll("'", "''");

    final endChar = (i == allQuestions.length - 1) ? ';' : ',';

    print(
        "('${q['question'].replaceAll("'", "''")}', '${q['subtitle']?.replaceAll("'", "''") ?? ''}', '${q['dimension']}', '$escapedOptions'::jsonb)$endChar");
  }
}
