// lib/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/plant_model.dart';
import '../../services/plant_service.dart';
import '../../services/user_service.dart';
import '../../widgets/plant_card.dart';
import '../../utils/constants.dart';
import '../settings/notifications_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final User? user = FirebaseAuth.instance.currentUser;
    final UserService _userService = UserService();

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. PROFILE HEADER ---
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                String? imageUrl;
                String name = user.displayName ?? "Plant Lover";

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  imageUrl = data?['profileImageUrl'];
                  name = data?['name'] ?? name;
                }

                return _buildProfileHeader(context, user, isDark, imageUrl, name);
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Favorites",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.primaryText
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- 2. DYNAMIC FAVORITES LIST ---
                  StreamBuilder<DocumentSnapshot>(
                    stream: _userService.getUserStream(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      List<String> favIds = [];
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data = snapshot.data!.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('favorites')) {
                          favIds = List<String>.from(data['favorites'] ?? []);
                        }
                      }
                      return _buildFavoritesSection(context, favIds, isDark);
                    },
                  ),

                  const SizedBox(height: 40),

                  // --- 3. SETTINGS MENU ---
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.primaryText
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildMenuTile(
                    context,
                    Icons.person_outline,
                    "Edit Profile",
                    isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  _buildMenuTile(
                    context,
                    Icons.notifications_none_outlined,
                    "Notifications",
                    isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
                    },
                  ),

                  // --- زر الخصوصية والأمان (الأسهل) ---
                  _buildMenuTile(
                    context,
                    Icons.shield_outlined,
                    "Privacy & Security",
                    isDark,
                    onTap: () => _showPrivacyDialog(context, isDark),
                  ),

                  const SizedBox(height: 20),

                  // --- 4. LOGOUT BUTTON ---
                  ListTile(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    tileColor: isDark ? Colors.redAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.05),
                    leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال المساعدة (Helper Functions) ---

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

  Widget _buildProfileHeader(BuildContext context, User user, bool isDark, String? imageUrl, String displayName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.buttonBG,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGreen, width: 2),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
              backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl)
                  : null,
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? const Icon(Icons.person, size: 50, color: AppColors.primaryGreen)
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            displayName,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.primaryText
            ),
          ),
          Text(
            user.email ?? "",
            style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkAccent : AppColors.primaryGreen.withOpacity(0.7)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context, List<String> favIds, bool isDark) {
    if (favIds.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.primaryGreen.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "No favorites yet",
            style: TextStyle(color: isDark ? AppColors.darkText.withOpacity(0.5) : Colors.grey),
          ),
        ),
      );
    }

    return StreamBuilder<List<PlantModel>>(
      stream: PlantService().getPlants(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final favPlants = snapshot.data!.where((p) => favIds.contains(p.id)).toList();

        if (favPlants.isEmpty) {
          return const Center(child: Text("No favorites found"));
        }

        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: favPlants.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SizedBox(
                width: 160,
                child: PlantCard(plant: favPlants[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuTile(BuildContext context, IconData icon, String title, bool isDark, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isDark ? AppColors.darkAccent : AppColors.primaryGreen),
        title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkText : AppColors.primaryText
            )
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white24 : Colors.grey),
      ),
    );
  }
}