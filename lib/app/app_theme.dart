import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:site_admin_pannel/app/app_colors.dart';

class AppTheme {
  final ThemeData appTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: AppColors.backgroundColor),
    fontFamily: GoogleFonts.raleway().fontFamily,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundColor,
  );
}
