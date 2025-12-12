import 'dart:ui';
import 'package:driftinn_mobile/core/services/auth_service.dart';
import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/features/mbti/screens/mbti_intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordEnterScreen extends StatefulWidget {
  final String email;
  final String phone;

  const PasswordEnterScreen({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  State<PasswordEnterScreen> createState() => _PasswordEnterScreenState();
}

class _PasswordEnterScreenState extends State<PasswordEnterScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isError
            ? Colors.red.withOpacity(0.9)
            : const Color(0xFF1D1A30), // Dark background
        behavior: SnackBarBehavior.floating, // Floating behavior
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Password validation state
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  String _strengthLabel = 'Weak';
  Color _strengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final text = _passwordController.text;
    setState(() {
      _hasMinLength = text.length >= 8;
      _hasNumber = text.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

      int score = 0;
      if (_hasMinLength) score++;
      if (_hasNumber) score++;
      if (_hasSpecialChar) score++;

      if (score == 3) {
        _strengthLabel = 'Strong';
        _strengthColor = Colors.green;
      } else if (score == 2) {
        _strengthLabel = 'Medium';
        _strengthColor = Colors.yellow;
      } else {
        _strengthLabel = 'Weak';
        _strengthColor = Colors.red;
      }
    });
  }

  Future<void> _handleSetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!_hasMinLength || !_hasNumber || !_hasSpecialChar) {
      _showSnackBar('Please meet all password requirements.', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with Firebase Auth
      final user = await _authService.signUpWithEmailAndPassword(
        widget.email,
        password,
      );

      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          _showSnackBar('Account Created Successfully!');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MbtiIntroScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });

        String errorMsg = 'Registration Failed.';
        if (e.code == 'email-already-in-use') {
          errorMsg = 'This email is already registered. Please login.';
        } else if (e.code == 'weak-password') {
          errorMsg = 'Password is too weak.';
        } else if (e.code == 'network-request-failed') {
          errorMsg = 'Network error. Check connection.';
        }

        _showSnackBar(errorMsg, isError: true);
      }
    } catch (e) {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('An unexpected error occurred: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  _buildBackButton(context),
                  Spacer(), // Or progress bar if needed
                  SizedBox(width: 40), // Balance
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Lock Icon
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      'Set Your Password',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.offWhite,
                        letterSpacing: -0.025,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Subtitle
                    Text(
                      'Create a strong password to secure your anonymous profile.',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.mutedGray,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // New Password Input
                    _buildLabel('New Password'),
                    const SizedBox(height: 8),
                    _buildPasswordInput(
                      controller: _passwordController,
                      hint: 'Enter new password',
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 24),

                    // Password Strength Meter
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.surfaceDark),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PASSWORD STRENGTH',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.mutedGray,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                _strengthLabel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _strengthColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Progress Bars
                          Row(
                            children: [
                              Expanded(child: _buildStrengthBar(0)),
                              const SizedBox(width: 4),
                              Expanded(child: _buildStrengthBar(1)),
                              const SizedBox(width: 4),
                              Expanded(child: _buildStrengthBar(2)),
                              const SizedBox(width: 4),
                              Expanded(child: _buildStrengthBar(3)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Checklist
                          _buildCheckItem(
                            _hasMinLength,
                            'At least 8 characters',
                          ),
                          const SizedBox(height: 8),
                          _buildCheckItem(_hasNumber, 'One number (0-9)'),
                          const SizedBox(height: 8),
                          _buildCheckItem(
                            _hasSpecialChar,
                            'One special character (!@#)',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirm Password Input
                    _buildLabel('Confirm Password'),
                    const SizedBox(height: 8),
                    _buildPasswordInput(
                      controller: _confirmPasswordController,
                      hint: 'Re-enter password',
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: Icons.lock_open,
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppTheme.backgroundDark.withOpacity(0.8),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shadowColor: AppTheme.primary.withOpacity(0.25),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Set Password',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppTheme.offWhite,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFD1D5DB), // gray-300
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.plusJakartaSans(color: AppTheme.offWhite),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1D1A30),
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildStrengthBar(int index) {
    // 4 bars.
    // Index 0, 1, 2, 3.
    // If progress is minimal, maybe only 0 is colored (red?).
    // If medium, 0 and 1 (yellow?).
    // If strong, all green?

    // Logic from HTML:
    // Weak: 1 bar red.
    // Medium: 2 bars yellow.
    // Strong: 4 bars green.

    Color color = const Color(0xFF374151); // gray-700
    if (_strengthLabel == 'Weak' && index < 1) color = Colors.red;
    if (_strengthLabel == 'Medium' && index < 2) color = Colors.yellow;
    if (_strengthLabel == 'Strong')
      color = Colors.green; // Changed from AppTheme.primary to Green

    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9999),
      ),
    );
  }

  Widget _buildCheckItem(bool checked, String text) {
    return Row(
      children: [
        Icon(
          checked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: checked ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: checked ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
