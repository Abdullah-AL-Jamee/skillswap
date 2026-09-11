import 'package:flutter/material.dart';

/// Colours, spacing and text styles taken from the SkillSwap high-fidelity
/// Figma prototype (Assessment 3) so that the running app matches the design
/// that was tested with users.
class AppColors {
  const AppColors._();

  /// Header / primary action colour used on every screen of the prototype.
  static const Color primary = Color(0xFF3C5A99);
  static const Color primaryDark = Color(0xFF2C4478);

  /// Headings and body copy.
  static const Color heading = Color(0xFF1F2A5B);
  static const Color body = Color(0xFF3D4356);
  static const Color muted = Color(0xFF7A8194);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF4F5F8);
  static const Color border = Color(0xFFD8DCE6);

  /// Avatar bubble on the mentor cards.
  static const Color avatarFill = Color(0xFFDCE3F8);
  static const Color avatarBorder = Color(0xFF6C7FD8);

  /// Skill tags.
  static const Color chipFill = Color(0xFFE4E7EE);

  static const Color star = Color(0xFFF5C518);

  /// Booking slot states. The green / salmon pair replaced the original grey
  /// slots after user testing, where testers could not tell open slots from
  /// taken ones.
  static const Color slotOpenFill = Color(0xFFB7E9C1);
  static const Color slotOpenBorder = Color(0xFF6FC384);
  static const Color slotOpenText = Color(0xFF1B6B3A);
  static const Color slotTakenFill = Color(0xFFF6BEB0);
  static const Color slotTakenBorder = Color(0xFFE0917C);
  static const Color slotTakenText = Color(0xFF9C3B22);
}

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.body,
        displayColor: AppColors.heading,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Shared heading used above each block of content.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
