import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/plant_model.dart';
import '../../services/user_service.dart';
import '../../utils/constants.dart';
import '../home/add_plant_screen.dart';

class PlantDetailsScreen extends StatelessWidget {
  final PlantModel plant;

  const PlantDetailsScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    // 1. التحقق من حالة الثيم والألوان الديناميكية
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final UserService _userService = UserService();
    final bool isMyPlant = plant.userId == currentUser?.uid;

    final Color textColor = isDark ? AppColors.darkText : AppColors.primaryText;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
                size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // قسم الصورة العلوي
            _buildImageHeader(isDark),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان وزر المفضلة
                  _buildTitleSection(_userService, currentUser, isDark, textColor),

                  const SizedBox(height: 35),

                  // قسم المتطلبات
                  Text(
                    "Plant Requirements",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 15),
                  _buildModernRequirementItem(
                    icon: Icons.wb_sunny_rounded,
                    label: "Lighting",
                    value: plant.sunlight,
                    iconColor: Colors.orange,
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                  _buildModernRequirementItem(
                    icon: Icons.water_drop_rounded,
                    label: "Humidity",
                    value: plant.humidity,
                    iconColor: Colors.blue,
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                  _buildModernRequirementItem(
                    icon: Icons.height_rounded,
                    label: "Height",
                    value: plant.height,
                    iconColor: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
                    cardColor: cardColor,
                    textColor: textColor,
                  ),

                  const SizedBox(height: 35),

                  // معلومات عامة
                  Text(
                    "General Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.03), blurRadius: 10)],
                    ),
                    child: Text(
                      plant.description,
                      style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                          height: 1.7
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context, isMyPlant, currentUser?.uid, isDark, cardColor),
    );
  }

  Widget _buildImageHeader(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.buttonBG,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Hero(
            tag: plant.id,
            child: plant.image.isNotEmpty
                ? Image.network(plant.image, height: 300, fit: BoxFit.contain)
                : const Icon(Icons.eco, size: 100, color: AppColors.primaryGreen),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(UserService userService, User? user, bool isDark, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: textColor),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkAccent.withOpacity(0.15) : AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  plant.category.toUpperCase(),
                  style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildFavoriteButton(userService, user, isDark),
      ],
    );
  }

  Widget _buildModernRequirementItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(UserService userService, User? user, bool isDark) {
    return StreamBuilder<DocumentSnapshot>(
      stream: userService.getUserStream(user!.uid),
      builder: (context, snapshot) {
        List favorites = [];
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          favorites = data['favorites'] ?? [];
        }
        bool isFav = favorites.contains(plant.id);
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
          ),
          child: IconButton(
            onPressed: () => userService.toggleFavorite(user.uid, plant.id),
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : AppColors.primaryGreen),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context, bool isMyPlant, String? uid, bool isDark, Color cardColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(35), topLeft: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.4 : 0.06), blurRadius: 20)],
      ),
      child: SafeArea(
        child: isMyPlant
            ? Row(
          children: [
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddPlantScreen(plantToEdit: plant))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  icon: const Icon(Icons.edit_rounded, color: Colors.white),
                  label: const Text("Edit Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 58,
                child: OutlinedButton(
                  onPressed: () => _showDeleteDialog(context, uid!, isDark),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                ),
              ),
            ),
          ],
        )
            : SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            onPressed: () => _sharePlantDetails(context, plant),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            label: const Text("Share Plant", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String uid, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Delete Plant?", style: TextStyle(color: isDark ? AppColors.darkText : Colors.black)),
        content: Text("Are you sure?", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(uid).collection('my_plants').doc(plant.id).delete();
              if (context.mounted) { Navigator.pop(context); Navigator.pop(context); }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _sharePlantDetails(BuildContext context, PlantModel plant) {
    final String message = '🌿 Check out this ${plant.name}!\n${plant.image}';
    Share.share(message);
  }
}