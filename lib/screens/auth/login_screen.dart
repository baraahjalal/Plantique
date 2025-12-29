// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantique_test/app/routes.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') errorMessage = 'No user found with this email.';
      else if (e.code == 'wrong-password') errorMessage = 'Incorrect password.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- NEW DESIGN: FLOATING ORGANIC IMAGE ---
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.45, // Slightly taller for better balance
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.buttonBG, // Matches your light beige
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 30,
                  right: 30,
                  bottom: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                      // --- FIX: CHANGED TO ASSET IMAGE ---
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo5.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centered for cleaner look
                children: [


                  const Text(
                    'Plantique',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Login to your account',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 40),

                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),

                  const SizedBox(height: 40),

                  CustomButton(
                    onPressed: _handleLogin,
                    text: 'Sign In',
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: RichText(
                      text: const TextSpan(
                        text: "New here? ",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        children: [
                          TextSpan(
                            text: "Create Account",
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}