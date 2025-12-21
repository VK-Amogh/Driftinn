import 'dart:ui';
import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/features/auth/screens/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RegistrationInfoScreen extends StatefulWidget {
  const RegistrationInfoScreen({super.key});

  @override
  State<RegistrationInfoScreen> createState() => _RegistrationInfoScreenState();
}

class _RegistrationInfoScreenState extends State<RegistrationInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  // Dropdown values
  String _selectedGradYear = '2026';
  String _selectedLevel = 'Undergraduate';
  DateTime? _selectedDate;

  final List<String> colleges = [
    'Manipal Institute of Technology',
    'NMAM Institute of Technology',
  ];

  final List<String> majors = [
    "Aeronautical Engineering",
    "Artificial Intelligence & Machine Learning",
    "Automobile Engineering",
    "Biomedical Engineering",
    "Biotechnology",
    "Chemical Engineering",
    "Civil Engineering",
    "Computer & Communication Engineering",
    "Computer Science & Engineering",
    "Data Science & Engineering",
    "Electrical & Electronics Engineering",
    "Electronics & Communication Engineering",
    "Industrial & Production Engineering",
    "Information Technology",
    "Mechanical Engineering",
    "Mechatronics",
  ];

  final List<String> levels = ["Undergraduate", "Graduate", "Postgraduate"];

  List<String> get gradYears {
    final currentYear = DateTime.now().year;
    // 2024 to 2028 based on HTML example range, extending dynamically
    return List.generate(6, (index) => (currentYear - 1 + index).toString());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: const Color(0xFF1E1E2E),
              headerBackgroundColor: AppTheme.primary,
              headerForegroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              dayStyle: GoogleFonts.plusJakartaSans(),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
                        width:
                            120, // max-w-xs approx equivalent relative to screen
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 30, // 1/4 width
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
                  const SizedBox(width: 40), // Balance the back button width
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 448,
                        ), // max-w-md
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal & College Info',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 30, // text-3xl
                                fontWeight: FontWeight.bold,
                                color: AppTheme.offWhite,
                                letterSpacing: -0.025, // tracking-tight
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This helps us verify you and find the best matches on your campus.',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.mutedGray,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // FORM
                            // Full Name
                            _buildLabel('Full Name'),
                            const SizedBox(height: 8),
                            _buildIconInput(
                              controller: _nameController,
                              icon: Icons.person_outline,
                              hint: 'Enter your full name',
                            ),
                            const SizedBox(height: 24),

                            // Birthdate
                            _buildLabel('Birthdate'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: _buildIconInput(
                                  controller: TextEditingController(
                                    text: _selectedDate == null
                                        ? ''
                                        : DateFormat(
                                            'MM/dd/yyyy',
                                          ).format(_selectedDate!),
                                  ),
                                  icon: Icons.cake_outlined,
                                  hint: 'MM/DD/YYYY',
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // College
                            _buildLabel('College/University Name'),
                            const SizedBox(height: 8),
                            // Using standard input style for visual match, even if searchable logic exists elsewhere
                            // For true 'searchable' + 'visual match', usually needs custom widget.
                            // Here implementing as styled DropdownMenu for best of both.
                            _buildSearchableDropdown(
                              controller: _collegeController,
                              hint: 'e.g., State University',
                              options: colleges,
                              icon: Icons.school_outlined,
                            ),
                            const SizedBox(height: 24),

                            // Grid Row: Grad Year & Level
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Graduation Year'),
                                      const SizedBox(height: 8),
                                      _buildSimpleDropdown(
                                        value: _selectedGradYear,
                                        items: gradYears,
                                        onChanged: (val) => setState(
                                          () => _selectedGradYear = val!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Level of Study'),
                                      const SizedBox(height: 8),
                                      _buildSimpleDropdown(
                                        value: _selectedLevel,
                                        items: levels,
                                        onChanged: (val) => setState(
                                          () => _selectedLevel = val!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Department
                            _buildLabel('Department/Major'),
                            const SizedBox(height: 8),
                            _buildSearchableDropdown(
                              controller: _departmentController,
                              hint: 'e.g., Computer Science',
                              options: majors,
                              icon: Icons.local_library_outlined,
                            ),

                            // Add extra padding at bottom for the fixed footer space if needed
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Footer
      bottomNavigationBar: Container(
        color: AppTheme.backgroundDark.withAlpha(204), // 0.8 opacity
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SafeArea(
                child: Center(
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 448),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate inputs
                            if (_nameController.text.isEmpty ||
                                _collegeController.text.isEmpty ||
                                _departmentController.text.isEmpty ||
                                _selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Collect data
                            final registrationData = {
                              'full_name': _nameController.text,
                              'dob': _selectedDate!.toIso8601String(),
                              'college': _collegeController.text,
                              'grad_year': _selectedGradYear,
                              'study_level': _selectedLevel,
                              'department': _departmentController.text,
                            };

                            // Navigate with data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailVerificationScreen(
                                  registrationData: registrationData,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Next',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFD1D5DB), // gray-300
      ),
    );
  }

  Widget _buildIconInput({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.plusJakartaSans(color: AppTheme.offWhite),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.surfaceDark,
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: AppTheme.mutedGray),
        prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)), // gray-400
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // pill shape
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppTheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  // Custom styled dropdown to match "form-select" appearing in HTML (caret on right, no icon on left for these specific ones)
  Widget _buildSimpleDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.offWhite,
          ), // Standard chevron
          dropdownColor: AppTheme.surfaceDark,
          isExpanded: true,
          style: GoogleFonts.plusJakartaSans(
            color: AppTheme.offWhite,
            fontSize: 16,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Combing search capability with the specific visual style (Icon on left)
  Widget _buildSearchableDropdown({
    required TextEditingController controller,
    required String hint,
    required List<String> options,
    required IconData icon,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<String>(
          width: constraints.maxWidth,
          controller: controller,
          enableFilter: true,
          requestFocusOnTap: true,
          hintText: hint,
          textStyle: GoogleFonts.plusJakartaSans(
            color: AppTheme.offWhite,
            fontSize: 16,
          ),
          leadingIcon: Icon(icon, color: const Color(0xFF9CA3AF)), // gray-400
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppTheme.surfaceDark,
            hintStyle: GoogleFonts.plusJakartaSans(color: AppTheme.mutedGray),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ), // Padding adjustment
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
              borderSide: const BorderSide(color: AppTheme.primary),
            ),
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppTheme.surfaceDark),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          dropdownMenuEntries: options.map<DropdownMenuEntry<String>>((
            String value,
          ) {
            return DropdownMenuEntry<String>(
              value: value,
              label: value,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(AppTheme.offWhite),
                textStyle: WidgetStateProperty.all(
                  GoogleFonts.plusJakartaSans(),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
