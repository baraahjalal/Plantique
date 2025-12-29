import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../screens/plants/plant_details_screen.dart';
import '../utils/constants.dart';

class PlantCard extends StatelessWidget {
  final PlantModel plant;

  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    // 1. التحقق من حالة الثيم الحالية
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailsScreen(plant: plant),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          // 2. تغيير لون الخلفية ديناميكياً
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              // في الوضع الداكن، نجعل الظل شفافاً جداً ليبدو طبيعياً
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image with Hero animation
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: Hero(
                  tag: plant.id,
                  child: plant.image.isNotEmpty
                      ? Image.network(
                    plant.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
                  )
                      : _buildPlaceholder(isDark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      // 3. تغيير لون النص حسب الثيم
                      color: isDark ? AppColors.darkText : AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.category,
                    style: TextStyle(
                      // 4. استخدام اللون الأخضر الفاتح في الداكن لسهولة القراءة
                      color: isDark ? AppColors.darkAccent : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: isDark ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ويدجيت تظهر في حال فشل تحميل الصورة أو عدم وجودها
  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: double.infinity,
      color: isDark ? AppColors.darkBackground : AppColors.buttonBG,
      child: Icon(
        Icons.eco,
        color: isDark ? AppColors.darkAccent : AppColors.primaryGreen,
        size: 40,
      ),
    );
  }
}