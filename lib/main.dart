import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:plantique_test/firebase_options.dart';
import 'package:plantique_test/providers/theme_provider.dart'; // Path to your provider
import 'app/app.dart';

void main() async {
  // التأكد من جاهزية المحرك قبل تشغيل الخدمات الخارجية
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة فايربيز مع إعدادات المنصة الحالية
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // تشغيل التطبيق مع تغليفه بـ ThemeProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}