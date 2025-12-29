// lib/screens/profile/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/constants.dart'; // استيراد الثوابت

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameController;
  late TextEditingController _photoUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: user?.displayName ?? "");
    _photoUrlController = TextEditingController(text: user?.photoURL ?? "");
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      await user?.updateDisplayName(_nameController.text);
      await user?.updatePhotoURL(_photoUrlController.text);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'name': _nameController.text,
        'profileImageUrl': _photoUrlController.text,
        'uid': user!.uid,
      }, SetOptions(merge: true));

      await user?.reload();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      }
    } catch (e) {
      debugPrint("❌ ERROR: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. تحديد حالة الثيم والألوان الديناميكية
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? AppColors.darkText : AppColors.primaryText;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color inputColor = isDark ? AppColors.darkBackground : AppColors.buttonBG;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Profile Settings",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Section Header
            Column(
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 28,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 30),
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.accentBrown,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),

            // Main Card
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: const Border(
                  right: BorderSide(color: AppColors.primaryGreen, width: 8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Profile Picture Preview
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryGreen, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: inputColor,
                          backgroundImage: _photoUrlController.text.isNotEmpty
                              ? NetworkImage(_photoUrlController.text)
                              : null,
                          child: _photoUrlController.text.isEmpty
                              ? const Icon(Icons.person, size: 60, color: AppColors.primaryGreen)
                              : null,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryGreen,
                        child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Form Fields
                  _buildStyledField(_nameController, "Full Name", Icons.person_outline, inputColor, textColor, isDark),
                  _buildStyledField(_photoUrlController, "Profile Image URL", Icons.link_outlined, inputColor, textColor, isDark),

                  const SizedBox(height: 10),
                  Text(
                    "Changes will reflect in the dashboard after saving.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "SAVE CHANGES",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledField(TextEditingController controller, String label, IconData icon, Color fieldColor, Color txtColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: TextStyle(color: txtColor),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryGreen),
              filled: true,
              fillColor: fieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            ),
          ),
        ],
      ),
    );
  }
}