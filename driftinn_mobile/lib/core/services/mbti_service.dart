import 'dart:math';
import 'package:driftinn_mobile/core/services/auth_service.dart';
import 'package:driftinn_mobile/core/services/database_service.dart';
import 'package:driftinn_mobile/features/mbti/models/mbti_question.dart';
import 'package:flutter/foundation.dart';
import 'package:driftinn_mobile/core/services/offline_question_bank.dart';
// Added this import

class MbtiService {
  // Store the active session's unique 25 questions
  List<MbtiQuestion> _currentSessionPlan = [];

  // Track scores: E vs I, S vs N, T vs F, J vs P
  // Also track Interest categories
  final Map<String, int> _sessionScores = {
    'E': 0, 'I': 0,
    'S': 0, 'N': 0,
    'T': 0, 'F': 0,
    'J': 0, 'P': 0,
    // Interests will be dynamic
  };

  // Track Interest counts
  final Map<String, int> _interestScores = {};

  MbtiService();

  String? getCurrentUserId() {
    return AuthService().currentUserId;
  }

  /// Starts the assessment by generating a UNIQUE, RANDOMIZED plan.
  Future<MbtiQuestion> startAssessment() async {
    _sessionScores.updateAll((key, value) => 0);
    _interestScores.clear();
    _generateRandomSession();
    return _currentSessionPlan[0];
  }

  /// Submits the answer (locally logged) and returns the NEXT question from the plan.
  Future<MbtiQuestion> submitAnswerAndGetNext(
    int currentStep,
    String answerText,
    String answerLabel,
  ) async {
    // 1. Record Score for the ANSWERED question
    // currentStep is the index of the question we just answered (0-indexed)
    if (currentStep < _currentSessionPlan.length) {
      final answeredQuestion = _currentSessionPlan[currentStep];
      // Find the selected option
      final selectedOption = answeredQuestion.options.firstWhere(
        (opt) => opt.label == answerLabel,
        orElse: () => answeredQuestion.options.first,
      );

      // Apply scores
      selectedOption.scores.forEach((key, value) {
        if (_sessionScores.containsKey(key)) {
          _sessionScores[key] = (_sessionScores[key] ?? 0) + value;
        } else {
          // It's an interest score
          _interestScores[key] = (_interestScores[key] ?? 0) + value;
        }
      });
    }

    // 2. Get Next Question
    int nextIndex = currentStep + 1;

    if (nextIndex >= _currentSessionPlan.length) {
      // Return last question to avoid crash if UI goes over
      return _currentSessionPlan.last;
    }

    return _currentSessionPlan[nextIndex];
  }

  /// Generates the Final detailed analysis report
  Future<Map<String, dynamic>> generateFinalReport(String userId) async {
    // 1. Calculate MBTI
    String mbtiType = _calculateFinalType();

    // 2. Calculate Top Interests
    List<String> topInterests = _calculateTopInterests();

    // 3. Generate Analysis (Mock text based on type)
    Map<String, dynamic> result = {
      "mbti_type": mbtiType,
      "confidence": "High", // Static for now
      "personality_summary": _getSummaryForType(mbtiType),
      "top_interests": topInterests,
      "compatible_types": _getCeompatibleTypes(mbtiType),
      "timestamp": DateTime.now().toIso8601String(),
    };

    // 4. Save to Database
    try {
      await DatabaseService().saveMbtiResult(userId, result);
    } catch (e) {
      debugPrint("Failed to save result to DB: $e");
      // Proceed returning result so UI can verify, even if save failed (retry later?)
    }

    return result;
  }

  // --- INTERNAL ENGINE ---

  String _calculateFinalType() {
    String e_i = (_sessionScores['E']! >= _sessionScores['I']!) ? 'E' : 'I';
    String s_n = (_sessionScores['S']! >= _sessionScores['N']!) ? 'S' : 'N';
    String t_f = (_sessionScores['T']! >= _sessionScores['F']!) ? 'T' : 'F';
    String j_p = (_sessionScores['J']! >= _sessionScores['P']!) ? 'J' : 'P';
    return "$e_i$s_n$t_f$j_p";
  }

  List<String> _calculateTopInterests() {
    var sortedKeys = _interestScores.keys.toList(growable: false)
      ..sort((k1, k2) =>
          (_interestScores[k2] ?? 0).compareTo(_interestScores[k1] ?? 0));
    return sortedKeys.take(3).toList();
  }

  String _getSummaryForType(String type) {
    const summaries = {
      'INTJ':
          "The Architect: Imaginative and strategic thinkers, with a plan for everything.",
      'INTP':
          "The Logician: Innovative inventors with an unquenchable thirst for knowledge.",
      'ENTJ':
          "The Commander: Bold, imaginative and strong-willed leaders, always finding a way.",
      'ENTP':
          "The Debater: Smart and curious thinkers who cannot resist an intellectual challenge.",
      'INFJ':
          "The Advocate: Quiet and mystical, yet very inspiring and tireless idealists.",
      'INFP':
          "The Mediator: Poetic, kind and altruistic people, always eager to help a good cause.",
      'ENFJ':
          "The Protagonist: Charismatic and inspiring leaders, able to mesmerize their listeners.",
      'ENFP':
          "The Campaigner: Enthusiastic, creative and sociable free spirits, who can always find a reason to smile.",
      'ISTJ':
          "The Logistician: Practical and fact-minded individuals, whose reliability cannot be doubted.",
      'ISFJ':
          "The Defender: Very dedicated and warm protectors, always ready to defend their loved ones.",
      'ESTJ':
          "The Executive: Excellent administrators, unsurpassed at managing things or people.",
      'ESFJ':
          "The Consul: Extraordinarily caring, social and popular people, always eager to help.",
      'ISTP':
          "The Virtuoso: Bold and practical experimenters, masters of all kinds of tools.",
      'ISFP':
          "The Adventurer: Flexible and charming artists, always ready to explore and experience something new.",
      'ESTP':
          "The Entrepreneur: Smart, energetic and very perceptive people, who truly enjoy living on the edge.",
      'ESFP':
          "The Entertainer: Spontaneous, energetic and enthusiastic people – life is never boring around them.",
    };
    return summaries[type] ?? "A unique and complex personality.";
  }

  List<String> _getCeompatibleTypes(String type) {
    return ["INTJ", "ENFP"]; // Placeholder logic
  }

  void _generateRandomSession() {
    _currentSessionPlan.clear();
    final random = Random();

    // 1. Get Pools (Copy them so valid changes don't affect static list)
    List<Map<String, dynamic>> poolA =
        List.from(OfflineQuestionBank.personalityQuestions);
    List<Map<String, dynamic>> poolB =
        List.from(OfflineQuestionBank.interestQuestions);

    // 2. Shuffle Pools to randomize order
    poolA.shuffle(random);
    poolB.shuffle(random);

    // 3. Select 15 Personality Questions
    // We want unique questions. Since we expanded the pool to >30, we can just take the first 15.
    for (int i = 0; i < 15; i++) {
      // Use modulo just in case pool is smaller than 15 (safety), but shuffle ensures randomness
      final data = poolA[i % poolA.length];
      _currentSessionPlan.add(_mapToQuestion(data, i + 1));
    }

    // 4. Select 10 Interest Questions
    for (int i = 0; i < 10; i++) {
      final data = poolB[i % poolB.length];
      // IDs continue from 16
      _currentSessionPlan.add(_mapToQuestion(data, 15 + i + 1));
    }

    debugPrint(
        "Generated Unique Session with ${_currentSessionPlan.length} questions.");
    if (_currentSessionPlan.isNotEmpty) {
      debugPrint("First Question: ${_currentSessionPlan[0].question}");
    }
  }

  MbtiQuestion _mapToQuestion(Map<String, dynamic> data, int index) {
    return MbtiQuestion(
      id: 'step_$index',
      question: data['question'],
      subtitle: data['subtitle'] ?? '',
      dimension: data['dimension'] ?? 'General',
      options: (data['options'] as List).map((opt) {
        return MbtiOption(
          label: opt['label'],
          text: opt['text'],
          scores:
              opt['scores'] != null ? Map<String, int>.from(opt['scores']) : {},
        );
      }).toList(),
    );
  }
}
