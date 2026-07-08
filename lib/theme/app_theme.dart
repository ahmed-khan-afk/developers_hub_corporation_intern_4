import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design tokens for the app's Neumorphic ("Soft UI") theme.
///
/// Neumorphism was chosen over flat/material defaults because it gives
/// the API-driven screens (posts, profiles) a tactile, premium feel —
/// every card, avatar and button appears to be molded out of the same
/// background surface using paired light/dark shadows instead of flat
/// elevation. A single accent gradient is layered on top for emphasis
/// (buttons, active nav item, progress ring) so the UI doesn't feel flat
/// or monotone the way pure neumorphism sometimes can.
class AppColors {
  AppColors._();

  // Base neumorphic surface (soft, low-contrast off-white).
  static const Color background = Color(0xFFE9EEF5);
  static const Color surface = Color(0xFFE9EEF5);

  // The two shadow tones that create the "molded" effect.
  static const Color shadowDark = Color(0xFFA9B4C4);
  static const Color shadowLight = Color(0xFFFFFFFF);

  // Accent gradient — used for CTAs, selected states, progress rings.
  static const Color accentStart = Color(0xFF6C5CE7);
  static const Color accentEnd = Color(0xFF00B4D8);

  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color danger = Color(0xFFE85D5D);
  static const Color success = Color(0xFF39B98C);

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentStart, accentEnd],
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.accentStart,
        secondary: AppColors.accentEnd,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
