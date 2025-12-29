import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/plant_model.dart';
import '../../services/plant_service.dart';
import '../../widgets/plant_card.dart';
import '../../utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final PlantService _plantService = PlantService();
  bool _showReadyPlants = true;

  @override
  Widget build(BuildContext context) {
    // 1. جلب حالة الثيم
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      // استخدام لون الخلفية من الثيم
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Explore Plants",
          style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.primaryText,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              style: TextStyle(color: isDark ? AppColors.darkText : AppColors.primaryText),
              decoration: InputDecoration(
                hintText: "Search for a plant...",
                hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                filled: true,
                // لون حقل البحث يتغير حسب الثيم
                fillColor: isDark ? AppColors.darkCard : Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none
                ),
              ),
            ),
          ),

          // أزرار التبديل (Tabs)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("Official", _showReadyPlants, isDark, () => setState(() => _showReadyPlants = true)),
                const SizedBox(width: 15),
                _buildTabButton("My Garden", !_showReadyPlants, isDark, () => setState(() => _showReadyPlants = false)),
              ],
            ),
          ),

          // عرض النتائج
          Expanded(
            child: StreamBuilder<List<PlantModel>>(
              stream: _showReadyPlants
                  ? _plantService.getPlants()
                  : _plantService.getUserPlants(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No plants found.",
                      style: TextStyle(color: isDark ? AppColors.darkText : Colors.grey),
                    ),
                  );
                }

                final results = snapshot.data!.where((plant) {
                  return plant.name.toLowerCase().contains(_searchQuery);
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) => PlantCard(plant: results[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isActive, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryGreen
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: isActive ? AppColors.primaryGreen : (isDark ? Colors.white24 : AppColors.primaryGreen.withOpacity(0.5))
          ),
          boxShadow: isActive
              ? [BoxShadow(color: AppColors.primaryGreen.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
              color: isActive ? Colors.white : (isDark ? AppColors.darkText : AppColors.primaryGreen),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}