// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart'; // المكتبة المسؤولة عن تسجيل الدخول والتحقق من الهوية
import '../models/user_model.dart'; // استيراد موديل المستخدم لنقوم بتعبئة بياناته بعد الدخول

class AuthService {
  // 1. إنشاء نسخة (Instance) من Firebase Authentication
  // الرمز (_) قبل الاسم يعني أن هذا المتغير "خاص" (Private) لا يمكن استخدامه خارج هذا الكلاس
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة مساعدة (Helper function) لتحويل كائن المستخدم القادم من فايربيز (User)
  // إلى الكائن الخاص بنا (UserModel) الذي قمنا بتصميمه في مجلد models
  UserModel? _userFromFirebaseUser(User? user) {
    // إذا كان المستخدم غير موجود (لم يسجل دخول)، نرجع null
    if (user == null) {
      return null;
    }
    // إذا وجدنا مستخدماً، نأخذ بياناته ونضعها في قالب الـ UserModel الخاص بنا
    return UserModel(
      uid: user.uid,              // المعرف الفريد للمستخدم
      email: user.email!,         // بريده الإلكتروني (استخدمنا ! للتأكيد أنه موجود)
      name: user.displayName,     // اسمه (إذا كان مسجلاً)
      profileImageUrl: user.photoURL, // رابط صورته الشخصية
    );
  }

  // 2. دالة تسجيل الدخول (Login Function)
  // نستخدم Future لأن العملية تأخذ وقتاً للرد من السيرفر، ونستخدم <UserModel?> لأنها قد تعيد مستخدماً أو لا شيء (null)
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      // استدعاء دالة فايربيز الرسمية للتحقق من الإيميل وكلمة السر
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // إذا نجحت العملية، نمرر المستخدم الناتج للدالة المساعدة ليتحول إلى UserModel
      return _userFromFirebaseUser(result.user);

    } on FirebaseAuthException catch (e) {
      // هنا نمسك الأخطاء الخاصة بفايربيز (مثلاً: كلمة سر خطأ، إيميل غير موجود)
      print('خطأ في تسجيل الدخول من فايربيز: ${e.code}');
      return null;

    } catch (e) {
      // نمسك أي أخطاء عامة أخرى قد تحدث (مثلاً: انقطاع الإنترنت)
      print(e.toString());
      return null;
    }
  }
}