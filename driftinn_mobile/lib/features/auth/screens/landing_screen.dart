import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:driftinn_mobile/features/auth/screens/registration_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    const primary = Color(0xFF412bee); // Neon Dark Blue (Fixed)
    const secondary = Color(0xFF2dd4bf);
    const backgroundDark = Color(0xFF0B0A16);
    const surfaceDark = Color(0xFF1C1A2E);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // --- Animated Background Orbs ---
          // Top Left Primary (Breathing & Moving)
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              return Positioned(
                top: -80 + (20 * math.sin(_orbController.value * 2 * math.pi)),
                left: -80 + (10 * math.cos(_orbController.value * 2 * math.pi)),
                child: Transform.scale(
                  scale: 1.0 + (0.1 * _orbController.value),
                  child: Container(
                    width: 384,
                    height: 384,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
              );
            },
          ),
          // Top Right Secondary
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.25 -
                    (20 * _orbController.value),
                right: -80 + (15 * math.sin(_orbController.value * math.pi)),
                child: Container(
                  width: 288,
                  height: 288,
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              );
            },
          ),
          // Bottom Left Purple
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              return Positioned(
                bottom: -80 + (30 * _orbController.value),
                left: -40 + (10 * math.cos(_orbController.value * math.pi)),
                child: Container(
                  width: 320, // w-80
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade600.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              );
            },
          ),

          // --- Background Curve (SVG Path) ---
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundCurvePainter(
                  startColor: primary, endColor: secondary),
            ),
          ),

          // --- Drifting Stars ---
          _animatedStar(
              top: 0.20,
              right: 0.25,
              size: 4,
              color: Colors.white,
              opacity: 0.6,
              speedScale: 1.0),
          _animatedStar(
              top: 0.15,
              left: 0.30,
              size: 2,
              color: secondary,
              opacity: 0.8,
              speedScale: 1.5),
          _animatedStar(
              bottom: 0.40,
              left: 0.10,
              size: 6,
              color: primary,
              opacity: 0.4,
              speedScale: 0.8),
          _animatedStar(
              bottom: 0.30,
              right: 0.20,
              size: 4,
              color: Colors.white,
              opacity: 0.3,
              speedScale: 1.2),
          _animatedStar(
              top: 0.40,
              right: 0.10,
              size: 4,
              color: Colors.purple.shade400,
              opacity: 0.5,
              speedScale: 1.0),

          // --- Content ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0), // p-8
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 40),

                  // Center Logo Part
                  Column(
                    children: [
                      // Icons Group
                      SizedBox(
                        height: 160,
                        width: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow - Fixed to be diffuse
                            AnimatedBuilder(
                                animation: _orbController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    // Gentle Pulse
                                    scale: 1.0 +
                                        (0.05 *
                                            math.sin(_orbController.value *
                                                2 *
                                                math.pi)),
                                    child: Container(
                                      width: 1, // Point source
                                      height: 1,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: primary.withOpacity(0.5),
                                            blurRadius: 60,
                                            spreadRadius: 40,
                                          ),
                                          BoxShadow(
                                              color: secondary.withOpacity(0.4),
                                              blurRadius: 60,
                                              spreadRadius: 30,
                                              offset: const Offset(15, -15)),
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                            // Main Card
                            Transform.rotate(
                              angle: 6 * 3.14159 / 180, // rotate-6
                              child: Container(
                                width: 112, // w-28
                                height: 112,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF151425),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.1)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.hub,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ),

                            // Floating small icons
                            // Positioned further out as requested
                            Positioned(
                              top: 0,
                              right: 0,
                              child: _floatingIcon(Icons.bolt, secondary, 16),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: _floatingIcon(Icons.favorite, primary, 14),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Text
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                            Color(0xFF9CA3AF) // gray-400
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          "Driftin",
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.0,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 15,
                                )
                              ]),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "DISCOVER CONNECTIONS",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: secondary,
                          letterSpacing: 3.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Anonymous-first matching.\nVerified students.\nReal friendships.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: Colors.grey[400],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Buttons
                  Column(
                    children: [
                      // Create Account Button - NEON EFFECT
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            // Main glow
                            BoxShadow(
                              color: const Color(0xFF412bee).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                            // Inner/surrounding glow for neon feel
                            BoxShadow(
                              color: const Color(0xFF412bee).withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF412bee), // Primary Neon
                              Color(0xFF565add), // Slight variation
                            ],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const RegistrationInfoScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Create Account",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Log In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: surfaceDark.withOpacity(0.5),
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Log In",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        "VERIFIED CAMPUS ACCESS ONLY",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: Colors.grey[600],
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _animatedStar({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required double opacity,
    required double speedScale,
  }) {
    return AnimatedBuilder(
      animation: _starController,
      builder: (context, child) {
        // Simple slow drift
        double offsetX =
            10 * math.sin(_starController.value * 2 * math.pi * speedScale);
        double offsetY =
            10 * math.cos(_starController.value * 2 * math.pi * speedScale);

        return Positioned(
          top: top != null
              ? MediaQuery.of(context).size.height * top + offsetY
              : null,
          bottom: bottom != null
              ? MediaQuery.of(context).size.height * bottom + offsetY
              : null,
          left: left != null
              ? MediaQuery.of(context).size.width * left + offsetX
              : null,
          right: right != null
              ? MediaQuery.of(context).size.width * right - offsetX
              : null,
          child: Opacity(
            opacity: opacity +
                (0.2 * math.sin(_starController.value * 10)), // Twinkle
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: size * 2,
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }

  Widget _floatingIcon(IconData icon, Color color, double size) {
    return Container(
      width: size * 3,
      height: size * 3,
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
            )
          ]),
      child: Icon(icon, color: color, size: size),
    );
  }
}

// Simple extension to mimic flutter_animate just for structure or ignore
extension on Widget {
  Widget animate() => this;
  Widget blur({required double begin, required double end}) => this;
}

class BackgroundCurvePainter extends CustomPainter {
  final Color startColor;
  final Color endColor;

  BackgroundCurvePainter({required this.startColor, required this.endColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(-50, 100);
    path.quadraticBezierTo(150, 250, 300, 150);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = ui.Gradient.linear(
        const Offset(-50, 100),
        const Offset(300, 150),
        [
          startColor.withOpacity(0.0),
          startColor.withOpacity(1.0),
          endColor.withOpacity(0.0)
        ],
        [0.0, 0.5, 1.0],
      );

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white.withOpacity(0.2));
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
