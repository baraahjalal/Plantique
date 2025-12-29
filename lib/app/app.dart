import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/theme_provider.dart'; // تأكدي من استيراد البروفايدر
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء البروفايدر لمراقبة التغيير في الثيم
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Plantique',
      debugShowCheckedModeBanner: false,

      // --- 1. إعدادات الوضع الفاتح (Light Mode) ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.buttonBG,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          brightness: Brightness.light,
          surface: AppColors.lightBackground,
        ),
        fontFamily: 'Cairo',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.primaryText),
          bodyMedium: TextStyle(color: AppColors.primaryText),
        ),
      ),

      // --- 2. إعدادات الوضع الداكن (Dark Mode) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.darkAccent,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkCard,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.darkAccent,
          brightness: Brightness.dark,
          surface: AppColors.darkCard, // يضمن تلون الخلفيات الداخلية بالداكن
        ),
        fontFamily: 'Cairo',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkText),
          bodyMedium: TextStyle(color: AppColors.darkText),
        ),
        // تحسين مظهر الأيقونات في الوضع الداكن
        iconTheme: const IconThemeData(color: AppColors.darkAccent),
      ),

      // --- الربط مع البروفايدر (هذا هو السر!) ---
      // بدلاً من System، نجعله يقرأ من الحالة التي يغيرها الزر
      themeMode: themeProvider.themeMode,

      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}