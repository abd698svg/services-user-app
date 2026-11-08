import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import all screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_requests_screen.dart';
import 'screens/request_details_screen.dart';
import 'screens/new_request_screen.dart';
import 'screens/clarification_screen.dart';
import 'screens/ai_analysis_screen.dart';
import 'screens/confirm_submission_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/change_password_screen.dart';

void main() {
  runApp(const SmartServiceApp());
}

class SmartServiceApp extends StatelessWidget {
  const SmartServiceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Service Request',
      debugShowCheckedModeBanner: false,
      
      // 1. Define the Global Theme based on DESIGN.md
      theme: _buildTheme(),

      // 2. App starts at the Splash Screen
      initialRoute: '/',

      // 3. Global Routing
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/my_requests': (context) => const MyRequestsScreen(),
        '/request_details': (context) => const RequestDetailsScreen(),
        '/new_request': (context) => const NewRequestScreen(),
        '/clarification': (context) => const ClarificationScreen(),
        '/ai_analysis': (context) => const AiAnalysisScreen(),
        '/confirm_submission': (context) => const ConfirmSubmissionScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
      },

      // 4. Force RTL for the entire app (Arabic interface)
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }

  // Helper method to build the exact ThemeData from DESIGN.md
  ThemeData _buildTheme() {
    // Brand Colors
    const Color primaryOrange = Color(0xFFF97316); // orange-500
    const Color backgroundWarm = Color(0xFFFFFBF7); // background
    const Color surfaceWhite = Colors.white; // surface
    const Color inkPrimary = Color(0xFF1C1917); // ink
    const Color inkSecondary = Color(0xFF57534E); // ink-secondary
    const Color inkMuted = Color(0xFF78716C); // ink-muted
    const Color borderSoft = Color(0xFFF1E7DD); // border-soft
    const Color errorRed = Color(0xFFDC2626); // error / safety
    const Color successGreen = Color(0xFF16A34A); // success

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundWarm,
      primaryColor: primaryOrange,
      colorScheme: const ColorScheme.light(
        primary: primaryOrange,
        surface: surfaceWhite,
        background: backgroundWarm,
        error: errorRed,
        onPrimary: Colors.white,
        onSurface: inkPrimary,
        onBackground: inkPrimary,
        onError: Colors.white,
      ),
      
      // Typography
      textTheme: GoogleFonts.ibmPlexSansArabicTextTheme().copyWith(
        displayLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 28, height: 38 / 28, fontWeight: FontWeight.w700, color: inkPrimary,
        ), // headline
        titleLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 22, height: 30 / 22, fontWeight: FontWeight.w600, color: inkPrimary,
        ), // title-large
        titleMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 18, height: 26 / 18, fontWeight: FontWeight.w600, color: inkPrimary,
        ), // title-medium
        bodyLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 16, height: 26 / 16, fontWeight: FontWeight.w400, color: inkPrimary,
        ), // body-large
        bodyMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 14, height: 22 / 14, fontWeight: FontWeight.w400, color: inkSecondary,
        ), // body-medium
        labelLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 16, height: 22 / 16, fontWeight: FontWeight.w700, color: Colors.white,
        ), // label-large (buttons)
        labelMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w600, color: inkPrimary,
        ), // label-medium (chips)
        labelSmall: GoogleFonts.ibmPlexSansArabic(
          fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500, color: inkMuted,
        ), // label-small (badges)
      ),

      // Global AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: inkPrimary),
        titleTextStyle: GoogleFonts.ibmPlexSansArabic(
          fontSize: 22, height: 30 / 22, fontWeight: FontWeight.w600, color: inkPrimary,
        ),
      ),

      // Global Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: GoogleFonts.ibmPlexSansArabic(color: inkMuted),
        floatingLabelStyle: GoogleFonts.ibmPlexSansArabic(color: primaryOrange),
        hintStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 14, color: const Color(0xFFA8A29E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE7DDD2), width: 1.5), // border token
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE7DDD2), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        errorStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 14, color: errorRed),
      ),

      // Global Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: surfaceWhite,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.ibmPlexSansArabic(
          fontSize: 18, fontWeight: FontWeight.w600, color: inkPrimary,
        ),
      ),

      // Global Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      
      // Global Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderSoft,
        thickness: 1,
        space: 1,
      ),
      
      // Global Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: inkPrimary,
        contentTextStyle: GoogleFonts.ibmPlexSansArabic(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
