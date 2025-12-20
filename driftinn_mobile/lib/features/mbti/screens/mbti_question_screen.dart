import 'package:driftinn_mobile/core/services/mbti_service.dart';
import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/features/mbti/models/mbti_question.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MbtiQuestionScreen extends StatefulWidget {
  const MbtiQuestionScreen({super.key});

  @override
  State<MbtiQuestionScreen> createState() => _MbtiQuestionScreenState();
}

class _MbtiQuestionScreenState extends State<MbtiQuestionScreen> {
  final MbtiService _mbtiService = MbtiService();
  bool _isLoading = true;
  String _errorMessage = '';

  MbtiQuestion? _currentQuestion;
  int _currentStep = 1;
  final int _totalSteps = 25;

  // Stores the selected option index (0-3) for the CURRENT question
  int? _selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    _startAssessment();
  }

  Future<void> _startAssessment() async {
    try {
      final question = await _mbtiService.startAssessment();
      if (mounted) {
        setState(() {
          _currentQuestion = question;
          _isLoading = false;
          _errorMessage = '';
          _currentStep = 1;
          _selectedOptionIndex = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              "Failed to start assessment. Please check your connection.";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitAndNext() async {
    if (_selectedOptionIndex == null || _currentQuestion == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedOption = _currentQuestion!.options[_selectedOptionIndex!];

      // If last step, we generate report instead of next question
      if (_currentStep >= _totalSteps) {
        await _finishTest();
        return;
      }

      final nextQuestion = await _mbtiService.submitAnswerAndGetNext(
        _currentStep,
        selectedOption.text,
        selectedOption.label,
      );

      if (mounted) {
        setState(() {
          _currentQuestion = nextQuestion;
          _currentStep++;
          _selectedOptionIndex = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error communicating with AI. Try again.";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _finishTest() async {
    final userId = _mbtiService.getCurrentUserId();

    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error: No user found. Cannot save results.")),
      );
      // Fallback nav
      Navigator.pushReplacementNamed(context, '/create_alias');
      return;
    }

    try {
      final report = await _mbtiService.generateFinalReport(userId);

      if (!mounted) return;

      final type = report['mbti_type'] ?? "Unknown";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Analysis Complete! Type: $type")),
      );

      // Navigate to Alias Creation
      Navigator.pushReplacementNamed(context, '/create_alias');
    } catch (e) {
      debugPrint("Error generating report: $e");
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/create_alias');
    }
  }

  void _handleBack() {
    // For adaptive test, "Back" is tricky because previous state is in AI history.
    // Simplest approach: Just pop if step 1, or show "Cannot go back in adaptive mode" toast.
    if (_currentStep == 1) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Adaptive test does not support going back yet."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Loading State
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppTheme.primary),
              const SizedBox(height: 16),
              Text(
                "Consulting AI Psychologist...",
                style: GoogleFonts.plusJakartaSans(color: AppTheme.offWhite),
              ),
              const SizedBox(height: 8),
              if (_currentStep > 1)
                Text(
                  "Analyzing step $_currentStep...",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.mutedGray,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // 2. Error State
    if (_errorMessage.isNotEmpty || _currentQuestion == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: GoogleFonts.plusJakartaSans(color: AppTheme.offWhite),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _startAssessment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Question UI
    final progress = _currentStep / _totalSteps;
    final progressPercent = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(progressPercent, progress),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildQuestionTag(),
                    const SizedBox(height: 16),

                    // Question Text
                    Text(
                      _currentQuestion!.question,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      _currentQuestion!.subtitle.isNotEmpty
                          ? _currentQuestion!.subtitle
                          : "Select the best option.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppTheme.mutedGray,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Options
                    ...List.generate(_currentQuestion!.options.length, (index) {
                      final option = _currentQuestion!.options[index];
                      final isSelected = _selectedOptionIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildOptionCard(option, index, isSelected),
                      );
                    }),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int progressPercent, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          if (_currentStep > 1)
            GestureDetector(
              onTap: _handleBack,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937).withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: AppTheme.offWhite,
                ),
              ),
            )
          else
            const SizedBox(width: 40), // Placeholder to keep spacing
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "PROGRESS",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.mutedGray,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$progressPercent%",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildQuestionTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Text(
        "QUESTION $_currentStep / $_totalSteps",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _selectedOptionIndex != null ? _submitAndNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            disabledBackgroundColor: const Color(0xFF1F2937),
            foregroundColor: Colors.white,
            elevation: _selectedOptionIndex != null ? 8 : 0,
            shadowColor: AppTheme.primary.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentStep == _totalSteps
                    ? 'Finish & Analyze'
                    : 'Next Question',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      _selectedOptionIndex != null ? Colors.white : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              if (_currentStep < _totalSteps)
                Icon(
                  Icons.arrow_forward,
                  color:
                      _selectedOptionIndex != null ? Colors.white : Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(MbtiOption option, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1F2937)
              : const Color(0xFF1F2937).withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppTheme.primary, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.grey.shade700,
                  width: 1,
                ),
              ),
              child: Text(
                option.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade300,
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.check_circle,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
