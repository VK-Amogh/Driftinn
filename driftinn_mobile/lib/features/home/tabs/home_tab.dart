import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Sticky-ish visuals, but placed here for scrolling)
          // Note: In HTML it was sticky, but simple ScrollView is safer for Flutter first pass unless Sliver used.
          // User asked for exact match, so let's stick to the visual look.
          _buildHeader(),
          const SizedBox(height: 24),

          // Grid: Type Card + Verification
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTypeCard(),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _buildVerificationCard(),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Daily Tip
          _buildDriftTip(),
          const SizedBox(height: 32),

          // Start Drift Button
          _buildNewDriftButton(),
          const SizedBox(height: 32),

          // Recent Vibes
          _buildRecentVibesHeader(),
          const SizedBox(height: 12),
          _buildRecentVibesList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.mutedGray, // #6C757D
              ),
            ),
            RichText(
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                children: [
                  const TextSpan(text: "Jessica "),
                  TextSpan(
                    text: "Wave",
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937), // bg-gray-800
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF9CA3AF), // text-gray-400
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFF374151),
                    width: 1), // border-gray-700
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primary, AppTheme.deepIndigo],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "JW",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32), // rounded-[2rem]
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A264D), Color(0xFF1A172E)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          // Glow effect
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              // Blur handled by parent usually, but simple opacity works for look
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "YOUR TYPE",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ENFP",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "The Campaigner",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF), // text-gray-400
                      ),
                    ),
                  ],
                ),
                // Bars
                Row(
                  children: [
                    Container(
                      height: 6,
                      width: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.electricTeal,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 6,
                      width: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF374151), // gray-700
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 6,
                      width: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF374151),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // bg-gray-800
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppTheme.electricTeal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified,
              color: AppTheme.electricTeal,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Verified",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "Student",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: const Color(0xFF6B7280), // gray-500
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriftTip() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937).withOpacity(0.6), // bg-gray-800/60
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Drift Tip",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '"Ask about their favorite hidden spot on campus. It\'s a great low-pressure icebreaker!"',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewDriftButton() {
    return Container(
      height: 144, // h-36 = 9rem = 144px
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(40), // rounded-[2.5rem]
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circles background
          Container(
            height: 256,
            width: 256,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          Container(
            height: 192,
            width: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.bolt,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Start a New Drift",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Anonymous Matching",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVibesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Recent Vibes",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD1D5DB), // gray-300
          ),
        ),
        Text(
          "View All",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentVibesList() {
    return Column(
      children: [
        _buildVibeItem(
          icon: Icons.psychology,
          iconColor: Colors.purple,
          title: "Matched with INTJ",
          subtitle: "2 hours ago • Philosophy Interest",
        ),
        const SizedBox(height: 12),
        _buildVibeItem(
          icon: Icons.school,
          iconColor: Colors.blue,
          title: "Campus Verified",
          subtitle: "Badge Earned",
        ),
      ],
    );
  }

  Widget _buildVibeItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937).withOpacity(0.4), // bg-gray-800/40
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor.withOpacity(0.8), size: 20),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: const Color(0xFF6B7280), // gray-500
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF4B5563), // gray-600
            size: 20,
          ),
        ],
      ),
    );
  }
}
