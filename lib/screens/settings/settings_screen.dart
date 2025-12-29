// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/constants.dart';
import '../profile/edit_profile_screen.dart'; // استيراد شاشة التعديل
import '../settings/notifications_screen.dart'; // استيراد شاشة التنبيهات

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? AppColors.darkText : AppColors.primaryText;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
            'Settings',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColors.darkAccent : AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. زر تعديل الملف الشخصي
            _buildSettingsItem(
              context: context,
              icon: Icons.person_outline,
              title: 'Edit Profile',
              textColor: textColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),

            // 2. زر التنبيهات
            _buildSettingsItem(
              context: context,
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              textColor: textColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                );
              },
            ),

            // 3. زر الخصوصية والأمان (نفس منطق شاشة البروفايل)
            _buildSettingsItem(
              context: context,
              icon: Icons.shield_outlined,
              title: 'Privacy & Security',
              textColor: textColor,
              onTap: () => _showPrivacyDialog(context, isDark),
            ),

            const SizedBox(height: 10),
            Divider(color: isDark ? Colors.white10 : Colors.black12),
            const SizedBox(height: 10),

            // 4. زر تسجيل الخروج
            _buildSettingsItem(
              context: context,
              icon: Icons.logout_rounded,
              title: 'Log Out',
              textColor: Colors.redAccent,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // دالة الخصوصية والأمان (Dialog)
  void _showPrivacyDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Privacy & Security",
          style: TextStyle(color: isDark ? AppColors.darkText : AppColors.primaryText),
        ),
        content: Text(
          "Your data is securely stored and encrypted via Firebase. We do not share your plant collection or personal info with third parties.",
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it!", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white, // أضفت خلفية بيضاء للفاتح أيضاً ليتناسق التصميم
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        leading: Icon(
            icon,
            color: title == 'Log Out' ? Colors.redAccent : (isDark ? AppColors.darkAccent : AppColors.primaryGreen)
        ),
        title: Text(
            title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500)
        ),
        trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? Colors.white24 : Colors.grey
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}