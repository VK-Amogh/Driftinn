import 'package:driftinn_mobile/core/theme/app_theme.dart';
import 'package:driftinn_mobile/features/auth/screens/registration_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact SVG path from login-reg-pg.html
    const String logoSvg =
        '''<svg fill="none" height="120" viewBox="0 0 120 120" width="120" xmlns="http://www.w3.org/2000/svg">
<circle cx="60" cy="60" fill="#6b5be6" r="60"></circle>
<path d="M78.636 50.844C78.636 44.856 83.508 40 89.52 40C95.532 40 100.404 44.856 100.404 50.844C100.404 56.832 95.532 61.688 89.52 61.688H78.636V50.844Z" fill="#f6f6f8"></path>
<path d="M41.364 69.156C41.364 75.144 36.492 80 30.48 80C24.468 80 19.596 75.144 19.596 69.156C19.596 63.168 24.468 58.312 30.48 58.312H41.364V69.156Z" fill="#f6f6f8"></path>
<path d="M41.364 50.844C41.364 44.856 46.236 40 52.248 40C58.26 40 63.132 44.856 63.132 50.844C63.132 56.832 58.26 61.688 52.248 61.688H41.364V50.844Z" fill="#f6f6f8"></path>
<path d="M78.636 69.156C78.636 75.144 73.764 80 67.752 80C61.74 80 56.868 75.144 56.868 69.156C56.868 63.168 61.74 58.312 67.752 58.312H78.636V69.156Z" fill="#f6f6f8"></path>
</svg>''';

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo
              SvgPicture.string(
                logoSvg,
                height: 120, // height="120"
                width: 120, // width="120"
              ),
              const SizedBox(height: 32), // pt-8 (32px)
              // 2. Title "Driftin"
              Text(
                'Driftin',
                style: GoogleFonts.inter(
                  fontSize: 32, // text-[32px]
                  fontWeight: FontWeight.w800, // font-extrabold
                  height: 1.25, // leading-tight
                  color: const Color(0xFFF6F6F8), // text-background-light
                  letterSpacing: -0.025, // tracking-tight
                ),
              ),
              const SizedBox(height: 12), // pb-3 (12px) approx adjustment
              // 3. Subtitle
              Text(
                'Find your people, anonymously.',
                style: GoogleFonts.inter(
                  fontSize: 16, // text-base
                  fontWeight: FontWeight.w400, // font-normal
                  height: 1.5, // leading-normal
                  color: Colors.grey[300], // text-gray-300
                ),
              ),
              const SizedBox(height: 48), // Spacing before buttons
              // 4. Register Button
              SizedBox(
                width: double.infinity,
                height: 56, // h-14 (56px)
                child: ElevatedButton(
                  onPressed: () {
                    // Smooth Transition to Registration
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const RegistrationInfoScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary, // bg-primary
                    foregroundColor: Colors.white, // text-white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // rounded-xl
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Register',
                    style: GoogleFonts.inter(
                      fontSize: 16, // text-base
                      fontWeight: FontWeight.bold, // font-bold
                      letterSpacing: 0.015 * 16, // tracking-[0.015em]
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12), // gap-3 (12px)
              // 5. Login Button
              SizedBox(
                width: double.infinity,
                height: 56, // h-14
                child: ElevatedButton(
                  onPressed: () {
                    // Login logic placeholder
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary.withAlpha(
                      51,
                    ), // bg-primary/20
                    foregroundColor: AppTheme.primary, // text-primary
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // rounded-xl
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.015 * 16,
                    ),
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
