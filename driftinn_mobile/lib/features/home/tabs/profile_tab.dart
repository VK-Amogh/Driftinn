import 'package:driftinn_mobile/core/services/auth_service.dart';
import 'package:driftinn_mobile/core/services/database_service.dart';
import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = _authService.currentUserId;
    if (uid != null) {
      final profile = await _databaseService.getUserProfile(uid);
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.primary));
    }

    // Default values if profile is null or fields missing
    final alias = _userProfile?['alias'] ?? 'Drifter';
    final photoUrl = _userProfile?['photo_url'];
    final bio = _userProfile?['bio'] ?? 'No bio yet.';

    final fullName =
        _userProfile?['full_name'] ?? _userProfile?['username'] ?? 'Anonymous';
    final collegeInfo = (_userProfile?['department'] != null &&
            _userProfile?['grad_year'] != null)
        ? "${_userProfile!['department']} • Class of ${_userProfile!['grad_year']}"
        : (_userProfile?['college'] ?? "No college info");

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Profile",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              // Settings Icon (Placeholder action)
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Profile Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar with Edit Button
                SizedBox(
                  height: 112,
                  width: 112,
                  child: Stack(
                    children: [
                      Container(
                        height: 112,
                        width: 112,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827), // gray-900
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1), width: 4),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppTheme.primary, AppTheme.deepIndigo],
                            ),
                            image: photoUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(photoUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: photoUrl == null
                              ? Text(
                                  alias.isNotEmpty
                                      ? alias[0].toUpperCase()
                                      : "?",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.electricTeal,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF1A172E), width: 4),
                          ),
                          child: const Icon(Icons.edit,
                              color: AppTheme.backgroundDark, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  collegeInfo,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 24),

                // Tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mbti if avail
                    if (_userProfile?['mbti_type'] != null)
                      _buildTag(Icons.psychology, AppTheme.primary,
                          _userProfile!['mbti_type'], true),
                    if (_userProfile?['mbti_type'] != null)
                      const SizedBox(width: 8),

                    _buildTag(Icons.verified, AppTheme.electricTeal,
                        "Verified Student", true),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // About Me
          _buildSectionHeader("About Me"),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Text(
              bio,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: const Color(0xFF9CA3AF), // gray-400
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Account Options
          _buildSectionHeader("Account"),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _buildAccountOption(Icons.logout, Colors.red, "Log Out",
                    onTap: () async {
                  await _authService.signOut();
                  // Navigate back to login
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFD1D5DB),
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, Color color, String label, bool isPill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // bg-primary/20
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOption(IconData icon, Color color, String label,
      {String? trailingText, Color? trailingColor, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              if (trailingText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    trailingText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: trailingColor ?? Colors.white,
                    ),
                  ),
                ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFF4B5563), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
