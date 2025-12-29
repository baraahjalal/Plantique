// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import 'package:plantique_test/app/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers to grab the text the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // --- THE REGISTRATION LOGIC ---
  void _handleRegister() async {
    setState(() => _isLoading = true);

    try {
      // 1. Create the user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // --- أضف هذا الجزء الجديد هنا ---
// هذا الجزء يقوم بتحديث اسم المستخدم في ملفه الشخصي بـ Firebase
      await userCredential.user?.updateDisplayName(_nameController.text.trim());
      await userCredential.user?.reload(); // لتحديث البيانات فوراً
// ------------------------------

      // بقية الكود الخاص بالـ Firestore كما هو...
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': DateTime.now(),
          'profileImageUrl': "",
          'favorites': [],
        });

        // 3. Success! Go to the Home Screen
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Show error (e.g., password too short, email already exists)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration Failed')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Join Plantique',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 10),
              const Text("Start your plant journey today",
                  style: TextStyle(color: Colors.grey)),

              const SizedBox(height: AppDimensions.largeSpacing),

              // Name Field
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: AppDimensions.mediumSpacing),

              // Email Field
              CustomTextField(
                controller: _emailController,
                labelText: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppDimensions.mediumSpacing),

              // Password Field
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: AppDimensions.largeSpacing),

              // Register Button
              CustomButton(
                onPressed: _handleRegister,
                text: 'Create Account',
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppDimensions.mediumSpacing),

              // Link to go back to Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}