import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_bus/app/theme/app_colors.dart';

/// Tipografía "Industry": Barlow Condensed para títulos sobre Barlow para
/// texto de cuerpo. Mismos nombres que antes de la retematización para no
/// tocar los call sites existentes (`AppTextStyles.body`, etc.).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get title => GoogleFonts.barlowCondensed(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.1,
      );

  static TextStyle get sectionTitle => GoogleFonts.barlowCondensed(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.15,
      );

  static TextStyle get cardTitle => GoogleFonts.barlowCondensed(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      );

  static TextStyle get body => GoogleFonts.barlow(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
      );

  static TextStyle get bodySecondary => GoogleFonts.barlow(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.neutral700,
      );

  static TextStyle get caption => GoogleFonts.barlow(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.neutral700,
        letterSpacing: 0.3,
      );

  static TextStyle get badge => GoogleFonts.barlowCondensed(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      );

  static TextStyle get etaValue => GoogleFonts.barlowCondensed(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.accent900,
        height: 0.95,
      );
}
