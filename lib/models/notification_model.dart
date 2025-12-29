import 'package:flutter/material.dart';

class PlantNotification {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color color;

  PlantNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    this.color = const Color(0xFF66774A),
  });
}