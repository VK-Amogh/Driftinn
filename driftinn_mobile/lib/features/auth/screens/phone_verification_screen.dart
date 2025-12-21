import 'dart:async';
import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/core/utils/toast_utils.dart';
import 'package:driftinn_mobile/core/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'password_enter_screen.dart';
import 'package:pinput/pinput.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> registrationData;

  const PhoneVerificationScreen({
    super.key,
    required this.email,
    required this.registrationData,
  });

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  final DatabaseService _databaseService = DatabaseService();
  final FocusNode _phoneFocusNode = FocusNode();

  // Status Messages
  String? _sendStatusMessage;
  Color _sendStatusColor = Colors.transparent;
  String? _verifyStatusMessage;
  final Color _verifyStatusColor = Colors.transparent;

  // Timer State
  Timer? _timer;
  int _start = 60;
  bool _isButtonDisabled = false;
  String _buttonText = 'Send OTP';
  bool _isSending = false;
  bool _isVerifying = false;
  bool _isAutoFilling = false;
  bool _isOtpError = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    _phoneFocusNode.dispose();
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
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      'Phone Number Verification',
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
                      "Enter your phone number to receive a verification code.",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.mutedGray,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Phone Number Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone Number',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.mutedGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Phone Input Row with Country Code
                    Container(
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D1A30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '🇮🇳 +91',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.offWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.offWhite,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: '(555) 000-0000',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: AppTheme.mutedGray,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Send OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (_isButtonDisabled || _isSending)
                            ? null
                            : () => _handleSendOtp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (_isButtonDisabled || _isSending)
                              ? AppTheme.mutedGray.withAlpha(50)
                              : AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          elevation: 0,
                        ),
                        child: _isSending
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isButtonDisabled
                                    ? 'Wait $_start s'
                                    : _buttonText,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: (_isButtonDisabled || _isSending)
                                      ? Colors.white.withAlpha(100)
                                      : Colors.white,
                                ),
                              ),
                      ),
                    ),

                    if (_sendStatusMessage != null) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _sendStatusMessage!,
                          style: GoogleFonts.plusJakartaSans(
                            color: _sendStatusColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // OTP Section
                    Text(
                      'Enter OTP',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.mutedGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A 6-digit code has been sent to your number.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: const Color(0xFF6B7280), // text-gray-500
                      ),
                    ),
                    const SizedBox(height: 12),

                    // OTP Row with Pinput
                    Pinput(
                      controller: _otpController,
                      focusNode: _otpFocusNode,
                      length: 6,
                      // androidSmsAutofillMethod:
                      //    AndroidSmsAutofillMethod.smsUserConsentApi,
                      // listenForMultipleSmsOnAndroid: true,
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
                          borderRadius: BorderRadius.circular(8),
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
                          borderRadius: BorderRadius.circular(8),
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
                          borderRadius: BorderRadius.circular(8),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_verifyStatusMessage != null) ...[
              Text(
                _verifyStatusMessage!,
                style: GoogleFonts.plusJakartaSans(
                  color: _verifyStatusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              height: 56,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : () => _handleVerifyOtp(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
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
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: "Didn't receive a code? ",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF6B7280),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Resend',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          color: const Color(0xFF1F2937).withOpacity(0.5), // bg-gray-800/50
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

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty && phone.length >= 10) {
      startTimer();
      setState(() {
        _isSending = true;
        _sendStatusMessage = 'Sending OTP...';
        _sendStatusColor = AppTheme.mutedGray;
        _isOtpError = false;
        _verifyStatusMessage = null;
      });

      try {
        final otp = (100000 + DateTime.now().microsecondsSinceEpoch % 900000)
            .toString();
        debugPrint('Phone OTP Generated: $otp');
        final fullPhone = '+91$phone'; // Append +91 here explicitly for backend

        try {
          await _databaseService
              .storePhoneOTP(fullPhone, otp)
              .timeout(const Duration(seconds: 2));
        } catch (e) {
          debugPrint('Store Phone OTP timeout (swallowed): $e');
        }

        if (context.mounted) {
          setState(() {
            _isSending = false;
            _sendStatusMessage = 'OTP sent to $fullPhone (Check Console: $otp)';
            _sendStatusColor = Colors.green;
          });

          // Auto-Fill & Auto-Verify Logic (Debug/Simulated)
          Future.delayed(const Duration(seconds: 1), () async {
            if (context.mounted) {
              setState(() {
                _isAutoFilling = true;
                _otpController.clear();
              });

              // Simulate typing one by one
              for (int i = 0; i < otp.length; i++) {
                if (!context.mounted) return;
                await Future.delayed(const Duration(milliseconds: 25));
                setState(() {
                  _otpController.text = otp.substring(0, i + 1);
                });
              }
            }
          });
        }
      } catch (e) {
        if (context.mounted) {
          setState(() {
            _isSending = false;
            _sendStatusMessage = 'Error sending OTP';
            _sendStatusColor = Colors.red;
          });
        }
      }
    } else {
      setState(() {
        _sendStatusMessage = 'Enter valid 10-digit number';
        _sendStatusColor = Colors.red;
      });
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpController.text.trim();
    final phone = _phoneController.text.trim();
    final fullPhone = '+91$phone';

    if (otp.length == 6 && phone.isNotEmpty) {
      setState(() {
        _isVerifying = true;
      });
      debugPrint('Verifying OTP: $otp for $fullPhone');
      bool success = false;
      try {
        success = await _databaseService
            .verifyPhoneOTP(fullPhone, otp)
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('Phone verify backend error/timeout: $e');
      }

      if (context.mounted) {
        debugPrint('Context mounted. Success: $success');
        if (success) {
          setState(() {
            _isVerifying = false;
            _isOtpError = false;
            _verifyStatusMessage = null;
          });
          ToastUtils.show(
            context,
            message: "Phone Verified Successfully!",
          );
          debugPrint('Navigating to PasswordEnterScreen...');
          // Navigate to Password Set Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                debugPrint('Building PasswordEnterScreen');
                return PasswordEnterScreen(
                  email: widget.email,
                  phone: _phoneController.text,
                  registrationData: widget.registrationData,
                );
              },
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
            message: "Wrong OTP or Verification Failed.",
            isError: true,
          );
        }
      } else {
        debugPrint('Context NOT mounted. Cannot navigate.');
      }
    }
  }
}
