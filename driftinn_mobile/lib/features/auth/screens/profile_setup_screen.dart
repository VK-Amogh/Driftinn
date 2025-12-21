import 'dart:io';
import 'package:driftinn_mobile/core/services/auth_service.dart';
import 'package:driftinn_mobile/core/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _bioController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to pick image: $e")),
        );
      }
    }
  }

  Future<void> _finish({bool skip = false}) async {
    setState(() => _isLoading = true);

    try {
      final userId = _authService.getCurrentUser()?.uid;
      if (userId == null) throw Exception("User not logged in");

      // Upload image if selected
      if (!skip && _selectedImage != null) {
        try {
          await _databaseService.uploadProfilePicture(userId, _selectedImage!);
        } catch (e) {
          debugPrint("Image upload failed but proceeding: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("Image upload failed: $e. Proceeding without it.")),
            );
          }
          // We proceed even if image fails, to unblock the user
        }
      }

      await _databaseService.updateUserProfile(
        userId,
        bio: skip ? null : _bioController.text.trim(),
      );

      // Navigate to Home
      if (mounted) {
        // Navigate to Home (MainScreen)
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF4b2bee);

    return Scaffold(
      backgroundColor: const Color(0xFF131022),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    "Step 3 of 5",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      "Complete Profile",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add a bio to help people know the real you.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Photo Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 140, // Slightly larger
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E1B2E),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.5),
                            width: 2,
                          ),
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: _selectedImage == null
                            ? Icon(Icons.add_a_photo_outlined,
                                color: primaryColor, size: 40)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedImage == null
                          ? "Tap to Add Photo"
                          : "Change Photo",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Bio Input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bio",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1B2E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: TextField(
                            controller: _bioController,
                            maxLines: 4,
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "I love hiking and sci-fi movies...",
                              hintStyle: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.3)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _finish(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Continue",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isLoading ? null : () => _finish(skip: true),
                    child: Text(
                      "Skip for now",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
