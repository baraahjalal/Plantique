import 'package:cloud_firestore/cloud_firestore.dart';

class PlantModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final String description;
  final String sunlight;
  final String humidity;
  final String height;
  final String? userId; // حقل جديد لتحديد صاحب النبات

  PlantModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    required this.sunlight,
    required this.humidity,
    required this.height,
    this.userId, // اختياري لأن النباتات الرسمية قد لا تملكه
  });

  factory PlantModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    return PlantModel(
      id: doc.id,
      name: data['name'] ?? 'Unknown Plant',
      category: data['category'] ?? 'Indoor',
      image: data['image'] ?? '',
      description: data['description'] ?? 'No description available.',
      sunlight: data['sunlight'] ?? 'Low to Medium Light',
      humidity: data['humidity'] ?? 'Normal',
      height: data['height'] ?? 'N/A',
      userId: data['userId'], // قراءة الـ ID من Firestore
    );
  }

  factory PlantModel.fromMap(Map<String, dynamic> map, String id) {
    return PlantModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      sunlight: map['sunlight'] ?? 'Medium',
      humidity: map['humidity'] ?? '50%',
      height: map['height'] ?? '30cm',
      userId: map['userId'], // قراءة الـ ID من الخريطة
    );
  }
}