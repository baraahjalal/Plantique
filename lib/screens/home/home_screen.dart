import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../widgets/plant_card.dart';
import '../../models/plant_model.dart';
import '../../services/plant_service.dart';
import '../../utils/constants.dart';
import '../../providers/theme_provider.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import 'add_plant_screen.dart';
import '../settings/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlantService _plantService = PlantService();
  int _selectedIndex = 0;
  String selectedCategory = "All";
  final List<String> categories = ["All", "Indoor", "Outdoor", "Office", "Palm Tree"];

  @override
  Widget build(BuildContext context) {
    // Listen to the provider to rebuild when theme changes
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.isDarkMode;

    final List<Widget> pages = [
      _buildHomeContent(context, isDark),
      const SearchScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      // Uses the background color defined in your app.dart theme
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(context, isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: AppColors.primaryGreen,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlantScreen())
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, bool isDark) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeader(context, isDark),
            const SizedBox(height: 12),
            Text(
              "Hey ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}",
              style: TextStyle(
                  color: isDark ? AppColors.darkAccent : AppColors.primaryGreen.withOpacity(0.7),
                  fontSize: 28,
                  fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Help Us To Save\nOur Mother Earth",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  color: isDark ? AppColors.darkText : AppColors.primaryText
              ),
            ),
            const SizedBox(height: 30),
            _buildCategoryRow(isDark),
            const SizedBox(height: 30),
            _buildPlantGrid(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
          builder: (context, snapshot) {
            String? imageUrl;
            if (snapshot.hasData && snapshot.data!.exists) {
              imageUrl = snapshot.data!.get('profileImageUrl');
            }

            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryGreen, width: 2),
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: isDark ? AppColors.darkCard : AppColors.buttonBG,
                backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? const Icon(Icons.person_rounded, color: AppColors.primaryGreen, size: 30)
                    : null,
              ),
            );
          },
        ),
        Row(
          children: [
            _headerIconButton(
              context,
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  () => themeProvider.toggleTheme(!isDark),
              iconColor: isDark ? Colors.orangeAccent : AppColors.primaryGreen,
            ),
            const SizedBox(width: 10),
            _headerIconButton(context, Icons.notifications_none_rounded, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            }),
            const SizedBox(width: 10),
            _headerIconButton(context, Icons.settings_outlined, () {
              Navigator.of(context).pushNamed('/settings');
            }),
          ],
        )
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context, bool isDark) {
    return BottomAppBar(
      color: isDark ? AppColors.darkCard : AppColors.buttonBG,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_filled, 0),
          _navIcon(Icons.explore_outlined, 1),
          const SizedBox(width: 40),
          _navIcon(Icons.notifications_active_outlined, 2),
          _navIcon(Icons.person_outline, 3),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final bool isActive = _selectedIndex == index;
    return IconButton(
        onPressed: () => setState(() => _selectedIndex = index),
        icon: Icon(
          icon,
          color: isActive ? AppColors.primaryGreen : Colors.grey.withOpacity(0.6),
          size: 28,
        )
    );
  }

  Widget _buildCategoryRow(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) => _buildCategoryItem(cat, isDark)).toList(),
      ),
    );
  }

  Widget _buildCategoryItem(String title, bool isDark) {
    bool isActive = selectedCategory == title;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = title),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryGreen
                : (isDark ? AppColors.darkCard : AppColors.primaryGreen.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(25)
        ),
        child: Text(
            title,
            style: TextStyle(
                color: isActive ? Colors.white : (isDark ? AppColors.darkText : AppColors.primaryGreen),
                fontWeight: FontWeight.bold
            )
        ),
      ),
    );
  }

  Widget _buildPlantGrid() {
    return StreamBuilder<List<PlantModel>>(
      stream: _plantService.getPlants(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var plants = snapshot.data!;
        if (selectedCategory != "All") plants = plants.where((p) => p.category == selectedCategory).toList();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18
          ),
          itemCount: plants.length,
          itemBuilder: (context, index) => PlantCard(plant: plants[index]),
        );
      },
    );
  }

  Widget _headerIconButton(BuildContext context, IconData icon, VoidCallback onTap, {Color? iconColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.buttonBG,
          borderRadius: BorderRadius.circular(15)
      ),
      child: IconButton(
          onPressed: onTap,
          icon: Icon(icon, size: 26, color: iconColor ?? AppColors.primaryGreen)
      ),
    );
  }
}