import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MbtiIntroScreen extends StatelessWidget {
  const MbtiIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackButton(context),
                  Text(
                    'Step 1 of 4',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.mutedGray,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Progress Bar
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.25,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Discover Your Personality',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.offWhite,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'This quick test helps us find your MBTI type. Your results will be used to match you with compatible friends on campus.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppTheme.mutedGray,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Illustration
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCDymu_7oHk5HpkyLYL45HmF44RwNcs0rlru7F0DUzr-rf0zuMRRdjLVSOU2VldKm_3wOYGgEwxoq5lhUVt9ec4d73tZfIogEzxeE9Ym5i1NF_gzyonBs_ap8ge5KJJlRg39B2xfBef4sgwvwoJYUmHnDmXhXuDZ2D3R10FA3dtA8ys-kUawLfRzSqXSj0xBNoNjSqhR3UEV7RiP6CNyUq1ANBqSxP70pjPsBCgNRgTv8idcNKfGaUPRshAdwvHabjhoSTErRPBSos3',
                          ),
                          fit: BoxFit.contain,
                        ),
                        // Fallback/loading logic could be added here, but keeping it simple for exact UI request
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Info Items
                    _buildInfoItem(
                      icon: Icons.schedule,
                      title: 'About 10 minutes',
                      subtitle:
                          "It's a small investment for better connections.",
                    ),
                    const SizedBox(height: 20),
                    _buildInfoItem(
                      icon: Icons.checklist,
                      title: 'Be yourself',
                      subtitle:
                          'Answer honestly for the most accurate matches.',
                    ),
                    const SizedBox(height: 20),
                    _buildInfoItem(
                      icon: Icons.lock,
                      title: 'Your results are private',
                      subtitle: 'Only shared with matches you approve.',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Test Screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: AppTheme.primary.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Start Test',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
          color: const Color(
            0xFF1F2937,
          ).withOpacity(0.5), // Matches previous screens
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

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.offWhite,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppTheme.mutedGray,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
