import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // نجعل الحالة الافتراضية تتبع إعدادات الهاتف
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // دالة للتحقق إذا كان الوضع الحالي هو الداكن
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // دالة التبديل
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // لتحديث كل الشاشات فوراً
  }
}