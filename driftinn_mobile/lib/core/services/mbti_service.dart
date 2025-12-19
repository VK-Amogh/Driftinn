import 'dart:convert';
import 'package:driftinn_mobile/features/mbti/models/mbti_question.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:google_generative_ai/google_generative_ai.dart';

class MbtiService {
  // Replace with the user's provided API Key
  static const String _apiKey = 'YOUR_API_KEY_HERE';

  late GenerativeModel _model;

  // History of the conversation/test session to give context to the AI
  final List<Content> _sessionHistory = [];

  MbtiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  /// Starts the assessment by fetching the first question.
  /// Clears previous history.
  Future<MbtiQuestion> startAssessment() async {
    _sessionHistory.clear();

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
    // gemini-1.5-flash is the most reliable and fastest for this API version
    const List<String> modelsToTry = ['gemini-1.5-flash'];

    String? lastError;

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

        // Add prompt temporarily.
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

        // Success!
        _sessionHistory.add(Content.model([TextPart(jsonString)]));
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
        lastError = e.toString();
        // Remove the failed prompt from history so we don't have it twice
        if (_sessionHistory.isNotEmpty) {
          _sessionHistory.removeLast();
        }
        continue; // Try next model
      }
    }

    // If ALL models fail, use OFFLINE SIMULATION silently
    debugPrint(
      "ALL AI MODELS FAILED. Switching to Offline Mode (Silent Fallback). Last Error: $lastError",
    );
    // Pass null as error so the UI doesn't show the error message to the user
    return _generateOfflineFallback(null);
  }

  /// Generates a valid question locally without AI using a predefined bank.
  MbtiQuestion _generateOfflineFallback(String? error) {
    // Determine the step number based on history length approximately
    // Each question adds 2 items (User Prompt + AI Response). +1 for System.
    // So (Length - 1) / 2 = Number of completed questions.
    int currentQuestionIndex = 0;
    if (_sessionHistory.isNotEmpty) {
      currentQuestionIndex = (_sessionHistory.length - 1) ~/ 2;
    }

    // Ensure we don't go out of bounds of our static list
    // We Loop if user goes beyond bank size
    final int index = currentQuestionIndex % _staticQuestions.length;

    final Map<String, dynamic> output = _staticQuestions[index];

    // Create a subtitle that includes the error ONLY for the first few failures to help debug
    String subtitle = output['subtitle'];
    if (error != null && currentQuestionIndex < 2) {
      subtitle += "\n[AI Error: $error]";
    } else {
      subtitle += " (Offline Backup Mode)";
    }

    return MbtiQuestion(
      id: 'offline_$index',
      question: output['question'],
      subtitle: subtitle,
      dimension: output['dimension'],
      options: (output['options'] as List).map((opt) {
        return MbtiOption(
          label: opt['label'],
          text: opt['text'],
          scores: Map<String, int>.from(opt['scores']),
        );
      }).toList(),
    );
  }

  // --- STATIC QUESTION BANK FOR OFFLINE MODE ---
  static const List<Map<String, dynamic>> _staticQuestions = [
    {
      "question": "At a party, do you usually...",
      "subtitle": "Let's start by gauging your social energy.",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Interact with many, including strangers.",
          "scores": {"E": 2},
        },
        {
          "label": "B",
          "text": "Interact with a few people known to you.",
          "scores": {"I": 2},
        },
        {
          "label": "C",
          "text": "Leave early to recharge.",
          "scores": {"I": 1},
        },
        {
          "label": "D",
          "text": "Host the party and entertain.",
          "scores": {"E": 3},
        },
      ],
    },
    {
      "question": "When solving a problem, do you prefer...",
      "subtitle": "How do you process information?",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Proven methods and concrete facts.",
          "scores": {"S": 2},
        },
        {
          "label": "B",
          "text": "New ideas and future possibilities.",
          "scores": {"N": 2},
        },
        {
          "label": "C",
          "text": "Using physical tools and hands-on work.",
          "scores": {"S": 1},
        },
        {
          "label": "D",
          "text": "Brainstorming abstract theories.",
          "scores": {"N": 1},
        },
      ],
    },
    {
      "question": "Creating a travel itinerary:",
      "subtitle": "Planning vs. Spontaneity.",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Plan every hour in detail.",
          "scores": {"J": 2},
        },
        {
          "label": "B",
          "text": "Have a rough list but go with the flow.",
          "scores": {"P": 1},
        },
        {
          "label": "C",
          "text": "Decide when I get there.",
          "scores": {"P": 2},
        },
        {
          "label": "D",
          "text": "Make a checklist of must-sees.",
          "scores": {"J": 1},
        },
      ],
    },
    {
      "question": "In a debate, is it more important to be:",
      "subtitle": "Heart vs. Head decision making.",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Truthful, even if it hurts feelings.",
          "scores": {"T": 2},
        },
        {
          "label": "B",
          "text": "Kind and maintain harmony.",
          "scores": {"F": 2},
        },
        {
          "label": "C",
          "text": "Objective and logical.",
          "scores": {"T": 1},
        },
        {
          "label": "D",
          "text": "Empathetic to the other side.",
          "scores": {"F": 1},
        },
      ],
    },
    {
      "question": "After a long week, you crave:",
      "subtitle": "Recharging Strategy.",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "A night out with friends.",
          "scores": {"E": 2},
        },
        {
          "label": "B",
          "text": "A quiet book or movie at home.",
          "scores": {"I": 2},
        },
        {
          "label": "C",
          "text": "A big concert or event.",
          "scores": {"E": 1},
        },
        {
          "label": "D",
          "text": "Solo hobby time.",
          "scores": {"I": 1},
        },
      ],
    },
    {
      "question": "You consider yourself more:",
      "subtitle": "Self-Perception.",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Realistic and Practical.",
          "scores": {"S": 2},
        },
        {
          "label": "B",
          "text": "Imaginative and Creative.",
          "scores": {"N": 2},
        },
        {
          "label": "C",
          "text": "Observant of details.",
          "scores": {"S": 1},
        },
        {
          "label": "D",
          "text": "Future-oriented vision.",
          "scores": {"N": 1},
        },
      ],
    },
    {
      "question": "Deadlines are:",
      "subtitle": "Time Management.",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Strict targets to be met early.",
          "scores": {"J": 2},
        },
        {
          "label": "B",
          "text": "Detailed suggestions.",
          "scores": {"P": 2},
        },
        {
          "label": "C",
          "text": "Stressful but necessary.",
          "scores": {"J": 1},
        },
        {
          "label": "D",
          "text": "Flexible markers.",
          "scores": {"P": 1},
        },
      ],
    },
    {
      "question": "When a friend is upset, you first:",
      "subtitle": "Emotional Response.",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Offer practical solutions.",
          "scores": {"T": 2},
        },
        {
          "label": "B",
          "text": "Listen and offer emotional support.",
          "scores": {"F": 2},
        },
        {
          "label": "C",
          "text": "Analyze why they are upset.",
          "scores": {"T": 1},
        },
        {
          "label": "D",
          "text": "Give them a hug.",
          "scores": {"F": 1},
        },
      ],
    },
  ];

  // Helper kept for legacy/fallback support if needed
  String calculateMbtiType(Map<String, int> scores) {
    // Simple mock calculation if needed locally
    int e = scores['E'] ?? 0;
    int i = scores['I'] ?? 0;
    // ... logic ...
    return "AI_DETERMINED";
  }
}
