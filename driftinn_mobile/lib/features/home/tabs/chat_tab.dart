import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        const TextSpan(text: "Matches "),
                        TextSpan(
                          text: "& Chats",
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF374151), width: 1),
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
          const SizedBox(height: 16),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF6B7280), size: 20),
                const SizedBox(width: 12),
                Text(
                  "Search matches...",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Subheader
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Active Drifts",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD1D5DB),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Sort by",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.sort, color: AppTheme.primary, size: 14),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Chat List
          _buildChatItem(
            type: "ESFP",
            colors: [Colors.pink, Colors.red],
            name: "Campus Explorer",
            msg: "Hey! Are you going to the mixer tonight?",
            time: "2m ago",
            unread: 2,
            verified: true,
            status: _buildStatusBatch(
              Icons.lock_open,
              "REVEAL READY",
              AppTheme.electricTeal,
            ),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            type: "INTJ",
            colors: [Colors.blue, Colors.indigo],
            name: "Chess Master",
            msg: "I think the strategy relies on opening...",
            time: "1h ago",
            unread: 1,
            status: _buildStatusBatch(
              Icons.timer,
              "14h to reveal",
              Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            type: "ISTP",
            colors: [Colors.orange, Colors.amber],
            name: "Tech Wizard",
            msg: "Sent a photo.",
            time: "3h ago",
            verified: true,
            status: _buildStatusBatch(
              Icons.timer,
              "2d to reveal",
              Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            type: "INFJ",
            colors: [Colors.green, Colors.teal],
            name: "Quiet Poet",
            msg: "Have you read that book yet?",
            time: "Yesterday",
            status: _buildStatusBatch(
              Icons.timer,
              "5h to reveal",
              Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            type: "?",
            colors: [Colors.grey.shade700, Colors.grey.shade800],
            name: "New Drift",
            msg: "Waiting for them to reply...",
            time: "Just now",
            isPending: true,
            status: _buildStatusBatch(
              Icons.hourglass_empty,
              "Pending",
              Colors.grey,
            ),
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              "You're all caught up!",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem({
    required String type,
    required List<Color> colors,
    required String name,
    required String msg,
    required String time,
    int unread = 0,
    bool verified = false,
    required Widget status,
    bool isPending = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Colors.white.withOpacity(isPending ? 0.05 : 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                height: 56,
                width: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: type == "?"
                    ? const Icon(Icons.help_outline,
                        color: Colors.grey, size: 24)
                    : Text(
                        type,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              if (verified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.backgroundDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: AppTheme.electricTeal,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isPending ? Colors.grey[400] : Colors.white,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  msg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isPending ? FontWeight.w400 : FontWeight.w500,
                    color: isPending
                        ? Colors.grey[600]
                        : (unread > 0 ? Colors.white : Colors.grey[400]),
                  ),
                ),
                const SizedBox(height: 8),
                status,
              ],
            ),
          ),
          // Unread Badge
          if (unread > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 20),
              child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unread.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBatch(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color == AppTheme.electricTeal
            ? AppTheme.electricTeal.withOpacity(0.1)
            : const Color(0xFF374151).withOpacity(0.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color == AppTheme.electricTeal
              ? AppTheme.electricTeal.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: color == Colors.grey ? const Color(0xFF9CA3AF) : color,
              size: 10),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color == Colors.grey ? const Color(0xFF9CA3AF) : color,
            ),
          ),
        ],
      ),
    );
  }
}
