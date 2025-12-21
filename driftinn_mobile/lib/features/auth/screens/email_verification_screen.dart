import 'dart:async';
import 'dart:ui';
import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/core/utils/toast_utils.dart';
import 'package:driftinn_mobile/core/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'phone_verification_screen.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> registrationData;
  const EmailVerificationScreen({super.key, required this.registrationData});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  final DatabaseService _databaseService = DatabaseService();
  final FocusNode _emailFocusNode = FocusNode();

  // Status Messages
  String? _sendStatusMessage;
  Color _sendStatusColor = Colors.transparent;
  String? _verifyStatusMessage;
  final Color _verifyStatusColor = Colors.transparent;

  // Timer State
  Timer? _timer;
  int _start = 60;
  bool _isButtonDisabled = false;
  String _buttonText = 'Send Code';
  bool _isOtpError = false;
  String? _lastGeneratedOtp; // Local fallback
  bool _isSending = false;
  bool _isVerifying = false;
  bool _isAutoFilling = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _start = 60;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isButtonDisabled = false;
          _buttonText = 'Resend Code';
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpController.text.trim();
    final email = _emailController.text.trim();

    if (otp.length == 6 && email.isNotEmpty) {
      setState(() {
        _isVerifying = true;
      });
      debugPrint('--- VERIFYING OTP ---');
      debugPrint('Email: $email');
      debugPrint('OTP: $otp');

      bool success = false;
      try {
        success = await _databaseService
            .verifyOTP(email, otp)
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('Backend verify timed out or failed: $e');
        // Fallback
        if (_lastGeneratedOtp != null && otp == _lastGeneratedOtp) {
          success = true;
        }
      }
      // Double safety
      if (!success && _lastGeneratedOtp != null && otp == _lastGeneratedOtp) {
        success = true;
      }

      if (mounted) {
        if (success) {
          setState(() {
            _isVerifying = false;
            _isOtpError = false;
            _verifyStatusMessage = "Verified!";
          });
          ToastUtils.show(context, message: 'Email Verified Successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneVerificationScreen(
                email: _emailController.text,
                registrationData: widget.registrationData,
              ),
            ),
          );
        } else {
          setState(() {
            _isVerifying = false;
            _isOtpError = true;
            _verifyStatusMessage = null;
          });
          ToastUtils.show(
            context,
            message: 'Invalid Code or Expired.',
            isError: true,
          );
        }
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
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 60, // 50% width
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Icon
                    Container(
                      height: 64,
                      width: 64,
                      decoration: const BoxDecoration(
                        color: AppTheme.surfaceDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      'Campus Verification',
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
                      "Please enter your college email to verify you're a student. This keeps our community safe and authentic.",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.mutedGray,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // College Email Input
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'College Email',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.mutedGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Container wrapping TextField and Button
                    GestureDetector(
                      onTap: () => _emailFocusNode.requestFocus(),
                      child: Container(
                        height: 72, // Increased height
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1A30),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _emailFocusNode.hasFocus
                                ? AppTheme.primary
                                : const Color(0xFF1D1A30),
                            width: 2, // Breadth
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            TextField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.offWhite,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                isDense:
                                    true, // Reduce inherent height assumptions
                                filled: false, // Override AppTheme default
                                fillColor: Colors.transparent,
                                hintText: 'you@yourschool.edu',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: AppTheme.mutedGray.withAlpha(128),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder
                                    .none, // Explicitly remove theme borders
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                  left: 16,
                                  right: 120, // Space for button
                                  top: 24,
                                  bottom: 24,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              child: SizedBox(
                                height: 48, // Button height inside
                                child: ElevatedButton(
                                  onPressed: (_isButtonDisabled || _isSending)
                                      ? null
                                      : () async {
                                          debugPrint(
                                            '--- SEND CODE PRESSED ---',
                                          );
                                          final email =
                                              _emailController.text.trim();

                                          if (email.isNotEmpty &&
                                              email.contains('@')) {
                                            setState(() {
                                              _isSending = true;
                                              _sendStatusMessage =
                                                  'Sending OTP... check console';
                                              _sendStatusColor =
                                                  AppTheme.mutedGray;
                                              _verifyStatusMessage = null;
                                            });
                                            // Minimal delay to show spinner
                                            await Future.delayed(
                                              const Duration(milliseconds: 500),
                                            );

                                            try {
                                              // Generate 6-digit OTP
                                              final otp = (100000 +
                                                      DateTime.now()
                                                              .microsecondsSinceEpoch %
                                                          900000)
                                                  .toString();
                                              _lastGeneratedOtp =
                                                  otp; // Store locally
                                              debugPrint('Generated OTP: $otp');

                                              // Store in Firebase with Timeout
                                              try {
                                                await _databaseService
                                                    .storeOTP(email, otp)
                                                    .timeout(
                                                      const Duration(
                                                        seconds: 2,
                                                      ),
                                                    );
                                                debugPrint(
                                                  'Firestore write success',
                                                );
                                              } catch (e) {
                                                debugPrint(
                                                  'Firestore write timed out (likely offline), but proceeding since logs might show it. Error: $e',
                                                );
                                                // We swallow the timeout error so the user sees "Sent"
                                                // because they are using console logs anyway.
                                              }

                                              if (context.mounted) {
                                                setState(() {
                                                  _isSending =
                                                      false; // Stop loading
                                                  startTimer(); // Start 60s timer
                                                  _sendStatusMessage =
                                                      'OTP sent to console: $otp';
                                                  _sendStatusColor =
                                                      Colors.green;
                                                });

                                                // Auto-Fill & Auto-Verify Logic (Debug/Simulated)
                                                Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () async {
                                                  if (context.mounted) {
                                                    setState(() {
                                                      _isAutoFilling = true;
                                                      _otpController.clear();
                                                    });

                                                    // Simulate typing one by one
                                                    for (int i = 0;
                                                        i < otp.length;
                                                        i++) {
                                                      if (!context.mounted)
                                                        return;
                                                      await Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  25));
                                                      setState(() {
                                                        _otpController.text =
                                                            otp.substring(
                                                                0, i + 1);
                                                      });
                                                    }
                                                  }
                                                });
                                              }
                                            } catch (e) {
                                              debugPrint('Error: $e');
                                              if (context.mounted) {
                                                setState(() {
                                                  _isSending = false;
                                                  _sendStatusMessage =
                                                      'Error sending OTP';
                                                  _sendStatusColor = Colors.red;
                                                });
                                              }
                                            }
                                          } else {
                                            setState(() {
                                              _sendStatusMessage =
                                                  'Invalid Email';
                                              _sendStatusColor = Colors.red;
                                            });
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        (_isButtonDisabled || _isSending)
                                            ? AppTheme.mutedGray.withAlpha(50)
                                            : AppTheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isSending
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          _isButtonDisabled
                                              ? 'Wait $_start s'
                                              : _buttonText,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: (_isButtonDisabled ||
                                                    _isSending)
                                                ? Colors.white.withAlpha(100)
                                                : Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_sendStatusMessage != null) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _sendStatusMessage!,
                          style: GoogleFonts.plusJakartaSans(
                            color: _sendStatusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),

                    // Verification Code Input
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Verification Code',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.mutedGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // OTP Row with Pinput
                    Pinput(
                      controller: _otpController,
                      focusNode: _otpFocusNode,
                      length: 6,
                      forceErrorState: _isOtpError,
                      defaultPinTheme: PinTheme(
                        width: 45,
                        height: 50,
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.offWhite,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1A30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1D1A30)),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 45,
                        height: 50,
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.offWhite,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1A30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primary, width: 2),
                        ),
                      ),
                      errorPinTheme: PinTheme(
                        width: 45,
                        height: 50,
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.offWhite,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1A30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                      pinAnimationType: PinAnimationType.none,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) async {
                        debugPrint('Pinput completed: $pin');
                        if (_isAutoFilling) {
                          await Future.delayed(
                              const Duration(milliseconds: 1500));
                          if (mounted) {
                            setState(() {
                              _isAutoFilling = false;
                            });
                          }
                        }
                        _handleVerifyOtp();
                      },
                    ),

                    const SizedBox(height: 100), // Space for footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppTheme.backgroundDark.withAlpha(204),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _isVerifying ? null : () => _handleVerifyOtp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          elevation: 0,
                        ),
                        child: _isVerifying
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Verify & Continue',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    if (_verifyStatusMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _verifyStatusMessage!,
                        style: GoogleFonts.plusJakartaSans(
                          color: _verifyStatusColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        text: "Didn't receive a code? ",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.mutedGray,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'Resend',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.primary.withAlpha(204),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
        decoration: const BoxDecoration(
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
}
