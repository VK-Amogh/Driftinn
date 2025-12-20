import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/features/home/tabs/chat_tab.dart';
import 'package:driftinn_mobile/features/home/tabs/home_tab.dart';
import 'package:driftinn_mobile/features/home/tabs/match_tab.dart';
import 'package:driftinn_mobile/features/home/tabs/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const MatchTab(),
    const ChatTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark, // #121022
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Body with Tabs
            IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),

            // Custom Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDark.withOpacity(0.95),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 32, // pb-8 from HTML
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home_filled, "Home"),
                    _buildNavItem(1, Icons.diversity_2, "Match"),
                    _buildNavItem(2, Icons.chat_bubble, "Chat", hasBadge: true),
                    _buildNavItem(3, Icons.person, "Profile"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label,
      {bool hasBadge = false}) {
    final bool isSelected = _currentIndex == index;
    final Color color = isSelected
        ? AppTheme.primary
        : AppTheme.mutedGray; // #412bee vs #6C757D

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: color,
                ),
                if (hasBadge)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        //  border: Border.all(color: AppTheme.backgroundDark, width: 2),
                        // HTML ring-2 ring-background-dark logic
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
