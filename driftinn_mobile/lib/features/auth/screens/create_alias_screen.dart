import 'package:driftinn_mobile/core/services/auth_service.dart';
import 'package:driftinn_mobile/core/services/database_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'profile_setup_screen.dart';

class CreateAliasScreen extends StatefulWidget {
  const CreateAliasScreen({super.key});

  @override
  State<CreateAliasScreen> createState() => _CreateAliasScreenState();
}

class _CreateAliasScreenState extends State<CreateAliasScreen> {
  final TextEditingController _aliasController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();

  String? _errorText;
  bool _isLoading = false;
  final bool _isChecking = false;

  void _generateAlias() {
    const adjectives = [
      'Electric',
      'Midnight',
      'Neon',
      'Cosmic',
      'Solar',
      'Lunar',
      'Cyber',
      'Silent',
      'Velvet',
      'Iron'
    ];
    const nouns = [
      'Ramen',
      'Tiger',
      'Phoenix',
      'Ninja',
      'Echo',
      'Viper',
      'Bloom',
      'Storm',
      'Shadow',
      'Spark'
    ];
    final random = Random();
    setState(() {
      _aliasController.text =
          "${adjectives[random.nextInt(adjectives.length)]}${nouns[random.nextInt(nouns.length)]}${random.nextInt(99)}";
    });
  }

  Future<void> _continue() async {
    final alias = _aliasController.text.trim();
    if (alias.length < 4 || alias.length > 16) {
      setState(() => _errorText = "4-16 characters required.");
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(alias)) {
      setState(() => _errorText = "No special symbols allowed.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // 1. Check uniqueness
      final isTaken = await _databaseService.isAliasTaken(alias);
      if (isTaken) {
        setState(() {
          _isLoading = false;
          _errorText = "This alias is already taken.";
        });
        return;
      }

      // 2. Save
      final userId = _authService.getCurrentUser()?.uid;
      if (userId == null) throw Exception("User not logged in");

      await _databaseService.setUserAlias(userId, alias);

      // 3. Navigate
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const ProfileSetupScreen()));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = "Something went wrong. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF4b2bee);

    return Scaffold(
      backgroundColor: const Color(0xFF131022), // Dark bg from HTML
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Back Button (Optional? Flow might be linear)
                  // IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  const Text(
                    "Step 2 of 5",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIndicator(true),
                const SizedBox(width: 8),
                _buildIndicator(true, half: true), // Current step partial
                const SizedBox(width: 8),
                _buildIndicator(false),
                const SizedBox(width: 8),
                _buildIndicator(false),
                const SizedBox(width: 8),
                _buildIndicator(false),
              ],
            ),

            const SizedBox(height: 32),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Create Your Alias",
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your temporary identity while you connect. Be creative!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Input Field
                    Center(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alias",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 56, // Fixed height for precision
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1B2E),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .stretch, // Ensure full height fill
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _aliasController,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "e.g., MidnightRamen",
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical:
                                              18, // Center text vertically
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  // Removed vertical divider for seamless look
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(16),
                                    ),
                                    child: InkWell(
                                      onTap: _generateAlias,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        right: Radius.circular(16),
                                      ),
                                      child: Container(
                                        width:
                                            56, // Square aspect for seamless button
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.auto_awesome,
                                          color: primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_errorText != null) ...[
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  _errorText!,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                "4-16 characters, no special symbols.",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.photo_camera_back,
                                color: primaryColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("No photo needed!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 2),
                                Text(
                                  "Connect based on personality first. Your identity is revealed only when you're ready.",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              // Removed top border line as requested
              child: ElevatedButton(
                onPressed: _isLoading ? null : _continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Make it fully round (stadium)
                  ),
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text("Continue",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool active, {bool half = false}) {
    return Container(
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF4b2bee).withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: active
          ? FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: half ? 0.5 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4b2bee),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
          : null,
    );
  }
}
