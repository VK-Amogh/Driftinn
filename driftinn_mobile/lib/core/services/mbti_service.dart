import 'dart:convert';
import 'package:driftinn_mobile/features/mbti/models/mbti_question.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:google_generative_ai/google_generative_ai.dart';

class MbtiService {
  // Replace with the user's provided API Key
  static const String _apiKey = 'AIzaSyDVNgAAibDauHkrxmpYFqOCXBo6kp19NOU';

  late GenerativeModel _model; // Removed 'final' to allow updates

  // History of the conversation/test session to give context to the AI
  final List<Content> _sessionHistory = [];

  MbtiService() {
    _model = GenerativeModel(
      model: 'gemini-pro', // Default starting model
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json', // Force JSON response
      ),
    );
  }

  /// Starts the assessment by fetching the first question.
  /// Clears previous history.
  Future<MbtiQuestion> startAssessment() async {
    _sessionHistory.clear();

    // Initial System Instruction for the "AI Psychologist"
    const String systemPrompt = """
      You are an expert Psychologist and Career Counselor AI. 
      Your goal is to determine a user's MBTI type AND core interests/hobbies in exactly 25 steps.
      
      This is an INTERACTIVE session. You will generate ONE question at a time.
      
      PHASE 1 (Questions 1-12): Focus on determining the 4 MBTI dimensions (E/I, S/N, T/F, J/P).
      PHASE 2 (Questions 13-25): Focus on specific interests, hobbies, and social preferences.
      
      OUTPUT FORMAT:
      Return a SINGLE JSON object for the next question.
      {
        "id": "step_X",
        "question": "The question text...",
        "subtitle": "Short context...",
        "dimension": "TARGET_DIMENSION_OR_TOPIC",
        "options": [
          { "label": "A", "text": "Option A", "scores": {"E": 2} },
          { "label": "B", "text": "Option B", "scores": {"I": 2} },
          { "label": "C", "text": "Option C", "scores": {"E": 1} },
          { "label": "D", "text": "Option D", "scores": {"I": 1} }
        ]
      }
    """;

    _sessionHistory.add(Content.text(systemPrompt));

    return _fetchNextQuestionFromAi(
      "Generate Question 1. Start with a broad scenario about a social situation to gauge Extroversion vs Introversion.",
    );
  }

  /// Submits the user's answer and gets the NEXT optimized question.
  Future<MbtiQuestion> submitAnswerAndGetNext(
    int currentStep,
    String answerText,
    String answerLabel,
  ) async {
    // 1. Add User's Answer to History so AI knows what they picked
    _sessionHistory.add(
      Content.model([
        TextPart("User selected Option $answerLabel: $answerText"),
      ]),
    );

    // 2. prompt for the next step
    String prompt = "";
    if (currentStep < 12) {
      prompt =
          "Generate Question ${currentStep + 1}. Analyze the previous answer. If the dimension is clear, switch to a new dimension (S/N, T/F, J/P). If unclear, dig deeper.";
    } else if (currentStep < 25) {
      prompt =
          "Generate Question ${currentStep + 1}. Phase 2 (Interests/Niche). Based on their previous answers, ask about specific hobbies or passions to narrow down their 'Vibe'.";
    } else {
      prompt = "Generate a final wrap-up question.";
    }

    return _fetchNextQuestionFromAi(prompt);
  }

  /// Generates the Final detailed analysis report
  Future<Map<String, dynamic>> generateFinalReport() async {
    const String analysisPrompt = """
       ALL 25 Questions are complete.
       Initialize a deep analysis of the user based on the entire chat history.
       
       Return JSON:
       {
         "mbti_type": "ENTJ",
         "confidence": "High",
         "personality_summary": "A 2-sentence summary of their vibe.",
         "top_interests": ["Tech", "Hiking", "Debate"],
         "compatible_types": ["INTP", "INFJ"]
       }
     """;

    _sessionHistory.add(Content.text(analysisPrompt));

    try {
      final response = await _model.generateContent(_sessionHistory);
      String text = response.text!.trim();
      if (text.startsWith('```json')) {
        text = text.replaceAll('```json', '').replaceAll('```', '');
      }
      return jsonDecode(text);
    } catch (e) {
      print("Analysis Error: $e");
      return {
        "mbti_type": "UNKNOWN",
        "personality_summary": "Could not generate analysis.",
        "top_interests": [],
      };
    }
  }

  Future<MbtiQuestion> _fetchNextQuestionFromAi(String prompt) async {
    // List of models to try in order of preference
    const List<String> modelsToTry = [
      'gemini-1.5-flash',
      'gemini-pro',
      'gemini-1.0-pro',
    ];

    for (final modelName in modelsToTry) {
      try {
        debugPrint("Trying AI model: $modelName...");
        final model = GenerativeModel(
          model: modelName,
          apiKey: _apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
          ),
        );

        // We create a temporary history for this attempt to avoid polluting the main history with failed attempts
        // Actually, we must add the prompt to the history sent to the model.
        // But since we modify _sessionHistory in place, we need to be careful.
        // A better approach: We only add to _sessionHistory once successful, or we use a copy.
        // For simplicity: We add the PROMPT to history. If it fails, we remove it.

        _sessionHistory.add(Content.text(prompt));
        final response = await model.generateContent(_sessionHistory);

        if (response.text == null) throw Exception("Empty AI Response");

        String rawText = response.text!.trim();
        debugPrint("AI RESPONSE ($modelName): $rawText");

        // JSON Extraction
        final int startIndex = rawText.indexOf('{');
        final int endIndex = rawText.lastIndexOf('}');
        if (startIndex == -1 || endIndex == -1)
          throw Exception("No JSON found");

        final String jsonString = rawText.substring(startIndex, endIndex + 1);
        final dynamic decoded = jsonDecode(jsonString);
        final Map<String, dynamic> json = (decoded is List)
            ? decoded.first
            : decoded;

        // Success! Update history using the SUCCESSFUL model's output
        _sessionHistory.add(Content.model([TextPart(jsonString)]));

        // Update the main _model to verify we found a working one (optional, but good for next call)
        _model = model;

        return MbtiQuestion(
          id: json['id'] ?? DateTime.now().toString(),
          question: json['question'],
          subtitle: json['subtitle'] ?? '',
          dimension: json['dimension'] ?? 'General',
          options: (json['options'] as List).map((opt) {
            return MbtiOption(
              label: opt['label'],
              text: opt['text'],
              scores: opt['scores'] != null
                  ? Map<String, int>.from(opt['scores'])
                  : {},
            );
          }).toList(),
        );
      } catch (e) {
        debugPrint("Model $modelName failed: $e");
        // Remove the failed prompt from history so we don't duplicate it on retry
        // The last item is the prompt we just added.
        if (_sessionHistory.isNotEmpty) {
          _sessionHistory.removeLast();
        }
        continue; // Try next model
      }
    }

    // If ALL models fail, use OFFLINE SIMULATION (Hard Fallback) to ensure app works
    debugPrint("ALL AI MODELS FAILED. Using Offline Simulation.");
    return _generateOfflineFallback(prompt);
  }

  /// Generates a valid question locally without AI, so the user can finish the flow.
  MbtiQuestion _generateOfflineFallback(String prompt) {
    // Generate a simple fallback ID based on time
    final String id = 'offline_${DateTime.now().millisecondsSinceEpoch}';

    return MbtiQuestion(
      id: id,
      dimension: 'General',
      question:
          "Since our AI is currently taking a nap (Connection Error), which of these describes you best?",
      subtitle: "Offline Backup Mode Active.",
      options: [
        MbtiOption(
          label: 'A',
          text: "I prefer clear plans and schedules.",
          scores: {'J': 2},
        ),
        MbtiOption(
          label: 'B',
          text: "I prefer to go with the flow.",
          scores: {'P': 2},
        ),
        MbtiOption(
          label: 'C',
          text: "I enjoy being center of attention.",
          scores: {'E': 2},
        ),
        MbtiOption(
          label: 'D',
          text: "I enjoy deep one-on-one talks.",
          scores: {'I': 2},
        ),
      ],
    );
  }

  // Helper kept for legacy/fallback support if needed
  String calculateMbtiType(Map<String, int> scores) {
    return "AI_DETERMINED";
  }
}
