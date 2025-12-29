import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primaryGreen = Color(0xFF66774A);
  static const Color accentBrown = Color(0xFFE1C5AF);

  // الخلفيات (تم تحديث القيم لتطابق الـ CSS مع الحفاظ على المسمى القديم)
  static const Color lightBackground = Color(0xFFF9F9F9); // من body background
  static const Color buttonBG = Color(0xFFF9F3EE);       // من footer-container

  // ألوان النصوص
  static const Color primaryText = Color(0xFF333333);     // بدلاً من الأسود الصريح لراحة العين
  static const Color mutedText = Color(0xFF66774A);

  // ألوان الـ Dark Mode (للاستخدام في الـ Theme)
  static const Color darkBackground = Color(0xFF2B1D12); // من body.dark-mode
  static const Color darkCard = Color(0xFF3D2B1F);       // من footer dark border
  static const Color darkText = Color(0xFFEFE7D9);       // من text dark
  static const Color darkAccent = Color(0xFFD4E0C0);     // من logo-text dark
}

class AppDimensions {
  static const double borderRadius = 20.0;
  static const double inputPadding = 16.0;
  static const double largeSpacing = 32.0;
  static const double mediumSpacing = 16.0;
}