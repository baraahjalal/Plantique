// lib/screens/settings/notifications_screen.dart

import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../utils/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. تحديد حالة الثيم
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // الألوان الديناميكية
    final Color textColor = isDark ? AppColors.darkText : AppColors.primaryText;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;

    // بيانات تجريبية (تم استبدال primaryGreen بالثابت العام)
    final List<PlantNotification> notifications = [
      PlantNotification(
        title: "Watering Reminder",
        body: "Your Monstera needs water! Check the soil moisture.",
        time: "2h ago",
        icon: Icons.water_drop,
        color: Colors.blue,
      ),
      PlantNotification(
        title: "New Plant Added",
        body: "You successfully added 'Snake Plant' to your collection.",
        time: "5h ago",
        icon: Icons.add_task,
        color: AppColors.primaryGreen,
      ),
      PlantNotification(
        title: "Sunlight Alert",
        body: "It's a sunny day! Move your succulents to the window.",
        time: "1d ago",
        icon: Icons.wb_sunny,
        color: Colors.orange,
      ),
      PlantNotification(
        title: "Welcome to Plantique",
        body: "Start your journey by exploring our plant catalog.",
        time: "2d ago",
        icon: Icons.celebration,
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent, // جعل الهيدر شفافاً ليعطي شعوراً عصرياً
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  // في الوضع الداكن، نزيد من شفافية الخلفية قليلاً لتكون الأيقونة واضحة
                  backgroundColor: item.color.withOpacity(isDark ? 0.2 : 0.1),
                  child: Icon(item.icon, color: item.color),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              item.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor
                              )
                          ),
                          Text(
                              item.time,
                              style: TextStyle(
                                  color: isDark ? Colors.white38 : Colors.grey,
                                  fontSize: 12
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                          item.body,
                          style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.grey[600],
                              fontSize: 14
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}