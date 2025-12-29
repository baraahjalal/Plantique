// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1. تحديد حالة الثيم الحالية
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // 2. تغيير لون خلفية الزر بناءً على الثيم
        // في الداكن نستخدم darkCard ليبرز عن الخلفية، وفي الفاتح نستخدم buttonBG
        backgroundColor: isDark ? AppColors.darkCard : AppColors.buttonBG,

        // 3. تغيير لون النص/المحتوى
        // في الداكن نستخدم darkAccent ليعطي مظهراً عصرياً، وفي الفاتح primaryGreen
        foregroundColor: isDark ? AppColors.darkAccent : AppColors.primaryGreen,

        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          // إضافة إطار بسيط في الوضع الداكن لزيادة الجمالية (اختياري)
          side: isDark
              ? BorderSide(color: AppColors.darkAccent.withOpacity(0.3), width: 1)
              : BorderSide.none,
        ),
        elevation: isDark ? 2 : 5, // تقليل الظل في الوضع الداكن لأنه لا يظهر بوضوح
      ),
      child: isLoading
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          // التأكد من أن لون مؤشر التحميل يتبع لون النص المختار أعلاه
          color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
          strokeWidth: 3,
        ),
      )
          : Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.40,
        ),
      ),
    );
  }
}