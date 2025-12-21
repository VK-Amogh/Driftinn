import 'package:driftinn_mobile/core/services/auth_service.dart';
import 'package:driftinn_mobile/core/services/database_service.dart';
import 'package:driftinn_mobile/features/auth/screens/registration_info_screen.dart';
import 'package:driftinn_mobile/core/utils/toast_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ToastUtils.show(
        context,
        message: 'Please enter email and password',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user =
          await _authService.signInWithEmailAndPassword(email, password);

      if (user != null) {
        // Recover User Logic: Ensure they exist in Supabase
        await _databaseService.saveUserData(user.uid, {
          'email': email,
        });
        // 2. Check Onboarding Status
        final status = await _databaseService.getUserOnboardingStatus(user.uid);

        if (!mounted) return;

        // 3. Smart Redirect
        if (status == 'completed') {
          // Profile Complete -> Home (Final Page)
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (status == 'profile_setup') {
          // MBTI Done, Alias Done -> Profile Setup
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/profile_setup', (route) => false);
        } else if (status == 'alias_creation') {
          // MBTI Done -> Create Alias
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/create_alias', (route) => false);
        } else {
          // Nothing Done -> Intro / MBTI
          // 'intro' route usually leads to MBTI
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/mbti_assessment', (route) => false);
        }
      } else {
        if (mounted) {
          ToastUtils.show(
            context,
            message: 'Login failed. Check credentials.',
            isError: true,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('--- LOGIN ERROR [FirebaseAuthException] ---');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');
      debugPrint('Stack: ${e.stackTrace}');
      debugPrint('-------------------------------------------');

      if (mounted) {
        setState(() => _isLoading = false);

        String errorMsg = 'Login Failed.';
        if (e.code == 'user-not-found') {
          errorMsg = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          errorMsg = 'Incorrect password.';
        } else if (e.code == 'invalid-email') {
          errorMsg = 'Invalid email address.';
        } else if (e.code == 'user-disabled') {
          errorMsg = 'User account has been disabled.';
        } else if (e.code == 'network-request-failed') {
          errorMsg = 'Network error. Check connection.';
        } else if (e.code == 'too-many-requests') {
          errorMsg = 'Blocked: Too many attempts. Wait 5 min.';
        } else if (e.code == 'unknown') {
          errorMsg = 'System Error: Check API Key / Network.';
        } else {
          errorMsg = '${e.message ?? "Unknown Error"} [${e.code}]';
        }

        ToastUtils.show(
          context,
          message: errorMsg,
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('--- LOGIN ERROR [General] ---');
      debugPrint('Error: $e');
      debugPrint('---------------------------');
      if (mounted) {
        ToastUtils.show(
          context,
          message: 'Error: ${e.toString()}',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Exact colors from code.html
    const primaryColor = Color(0xFF412bee);
    const backgroundColor = Color(0xFF121022); // bg-background-dark
    const inputFillColor = Color(
        0xFF1F2937); // rough logic, but code.html uses bg-gray-800. Tailwind gray-800 is #1f2937.
    // However, code.html text colors:
    // "Welcome Back" -> text-white
    // Subtext -> text-gray-400
    // Labels -> text-gray-300

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        // Changed to SingleChildScrollView for safety on small screens
        child: Container(
          height: MediaQuery.of(context).size.height, // Ensure min height
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure full width
            children: [
              const SizedBox(height: 56), // top-14 approx

              // Spacer/Flex equivalent
              const Spacer(),

              // Header Center
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 80, // h-20
                      width: 80, // w-20
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2), // bg-primary/20
                          borderRadius:
                              BorderRadius.circular(16), // rounded-2xl
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 10, // shadow-lg approx
                              offset: const Offset(0, 10),
                            )
                          ]),
                      child: const Icon(Icons.diversity_3,
                          color: primaryColor, size: 36), // text-4xl
                    ),
                    const SizedBox(
                        height:
                            24), // mb-6 (icon) -> mb-10 (text center) difference
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30, // text-3xl
                        fontWeight: FontWeight.bold, // font-bold
                        color: Colors.white,
                        letterSpacing: -0.025, // tracking-tight
                      ),
                    ),
                    const SizedBox(height: 8), // mb-2
                    Text(
                      "Login to continue your anonymous journey on Driftin.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16, // text-base
                        color: const Color(0xFF9CA3AF), // text-gray-400
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40), // mb-10

              // Form
              // Email
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8), // ml-1 mb-2
                child: Text(
                  "Email or Phone Number",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, // text-sm
                    fontWeight: FontWeight.w500, // font-medium
                    color: const Color(0xFFD1D5DB), // text-gray-300
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  TextField(
                    controller: _emailController,
                    style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFF8F9FA)), // text-off-white
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1F2937), // bg-gray-800
                      hintText: "example@college.edu",
                      hintStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6B7280)), // text-gray-500
                      contentPadding: const EdgeInsets.fromLTRB(
                          48, 20, 16, 20), // h-14 vertical padding roughly
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: primaryColor,
                            width: 2), // focus:ring-primary
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 16, // left-4
                    child: Icon(Icons.mail_outline,
                        color: Color(0xFF6B7280), size: 24), // text-gray-500
                  ),
                ],
              ),

              const SizedBox(height: 24), // space-y-6

              // Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      "Password",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFD1D5DB), // text-gray-300
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFF8F9FA)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1F2937),
                      hintText: "Enter your password",
                      hintStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6B7280)),
                      contentPadding: const EdgeInsets.fromLTRB(48, 20, 48, 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 16,
                    child: Icon(Icons.lock_outline,
                        color: Color(0xFF6B7280), size: 24),
                  ),
                  Positioned(
                    right: 16, // right-4
                    child: GestureDetector(
                      onTap: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFF9CA3AF), // text-gray-400
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40), // mt-10

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56, // h-14
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shadowColor:
                        primaryColor.withOpacity(0.25), // shadow-primary/25
                    elevation: 8, // shadow-lg
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          999), // rounded-full (as per code.html button)
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(
                          "Login",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18, // text-lg
                            fontWeight: FontWeight.bold, // font-bold
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16), // space-y-4

              // OR Divider
              Row(
                children: [
                  Expanded(
                      child: Divider(color: Colors.grey[800], thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "or",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, // text-sm
                        color: const Color(0xFF6B7280), // text-gray-500
                      ),
                    ),
                  ),
                  Expanded(
                      child: Divider(color: Colors.grey[800], thickness: 1)),
                ],
              ),

              const SizedBox(height: 16),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegistrationInfoScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937), // bg-gray-800
                    side: const BorderSide(
                        color: Color(0xFF374151)), // border-gray-700
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999), // rounded-full
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Register New Account",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, // text-lg
                      fontWeight: FontWeight.w500, // font-medium
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Footer
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  "By logging in, you agree to our Terms & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, // text-xs
                    color: const Color(0xFF4B5563), // text-gray-600
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
