// lib/widgets/custom_textfield.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // 1. تحديد حالة الثيم
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // 2. استخدام لون خلفية داكن في الـ Dark Mode
        color: isDark ? AppColors.darkBackground : AppColors.buttonBG,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            // تقليل الظل في الوضع الداكن لجعله يبدو أنيقاً
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        // 3. تغيير لون الخط المكتوب
        style: TextStyle(color: isDark ? AppColors.darkText : AppColors.primaryText),
        decoration: InputDecoration(
          labelText: labelText,
          // 4. تغيير لون الـ Label ليكون أوضح في الداكن
          labelStyle: TextStyle(
              color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
              fontWeight: FontWeight.w500
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: isDark ? AppColors.darkAccent : AppColors.primaryGreen)
              : null,

          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
                  width: 2
              ),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius)
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    );
  }
}