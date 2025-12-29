// lib/app/routes.dart

import 'package:flutter/material.dart';
// استيراد الشاشات من مجلداتها الخاصة لكي نتمكن من ربطها بالمسارات
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  // تعريف أسماء المسارات كـ "نصوص ثابتة" (Static Constants)
  // الفائدة: تجنب الأخطاء الإملائية؛ بدلاً من كتابة '/login' يدوياً في كل مرة، نستخدم AppRoutes.login

  static const String login = '/';           // المسار الرئيسي (يبدأ التطبيق من هنا عادةً)
  static const String home = '/home';         // مسار الشاشة الرئيسية
  static const String register = '/register'; // مسار شاشة إنشاء حساب جديد
  static const String settings = '/settings'; // مسار شاشة الإعدادات

  // هذه "الخريطة" (Map) تربط كل اسم مسار (String) بالـ Widget الخاص بالشاشة (Builder)
  // الـ WidgetBuilder هو وظيفة تأخذ الـ context وتعيد لنا الشاشة المطلوبة
  static Map<String, WidgetBuilder> get routes {
    return {
      // عند طلب المسار '/'، سيقوم التطبيق بفتح شاشة LoginScreen
      login: (context) => const LoginScreen(),

      // عند طلب المسار '/home'، سيقوم التطبيق بفتح شاشة HomeScreen
      home: (context) => const HomeScreen(),

      // ربط مسار الإعدادات بشاشتها الخاصة
      settings: (context) => const SettingsScreen(),

      // ربط مسار التسجيل بشاشته الخاصة
      register: (context) => const RegisterScreen(),
    };
  }
}