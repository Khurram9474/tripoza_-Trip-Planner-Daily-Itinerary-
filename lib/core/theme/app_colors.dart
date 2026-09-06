import 'package:flutter/material.dart';

/// Centralized color palette for Tripora.
/// No widget should hardcode a Color value — always reference AppColors.
class AppColors {
  AppColors._();

  // Primary — Deep Travel Blue
  static const Color primary = Color(0xFF1B3A6B);
  static const Color primaryLight = Color(0xFF2E5590);
  static const Color primaryDark = Color(0xFF0F2547);

  // Secondary — Turquoise/Teal
  static const Color secondary = Color(0xFF2DBEB0);
  static const Color secondaryLight = Color(0xFF6FDCD1);

  // Background & Surface
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEFF1F5);

  // Text
  static const Color textPrimary = Color(0xFF1C2331);
  static const Color textSecondary = Color(0xFF5B6472);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFE8912D);
  static const Color error = Color(0xFFD8483C);

  // Trip status specific tints (background for badges)
  static const Color upcomingBg = Color(0xFFE3ECFB);
  static const Color upcomingText = Color(0xFF2E5590);
  static const Color ongoingBg = Color(0xFFE1F7EE);
  static const Color ongoingText = Color(0xFF2E9E5B);
  static const Color completedBg = Color(0xFFEFF1F5);
  static const Color completedText = Color(0xFF5B6472);

  // Category colors (used behind category icons)
  static const Color sightseeing = Color(0xFF2E5590);
  static const Color food = Color(0xFFE8912D);
  static const Color adventure = Color(0xFF2E9E5B);
  static const Color shopping = Color(0xFFB4589A);
  static const Color culture = Color(0xFF7D5BA6);
  static const Color entertainment = Color(0xFFD8483C);

  // Misc
  static const Color divider = Color(0xFFE3E6EB);
  static const Color shadow = Color(0x1A1C2331);
}