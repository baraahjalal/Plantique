// lib/services/plant_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant_model.dart';

class PlantService {
  // 1. Create an instance of Firebase Firestore
  // This is like opening a connection to your online database cabinet
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 2. The "Get Plants" Stream
  // A 'Stream' is like a live YouTube video.
  // Whenever you change something in Firebase, this 'Stream' automatically
  // sends the new data to your app without you having to refresh!
  Stream<List<PlantModel>> getPlants() {
    return _db
        .collection('plantss') // Looks for the folder named 'plants' in Firebase
        .snapshots()         // Takes a "snapshot" of what's inside right now
        .map((snapshot) {
      // We turn every document from Firebase into our 'PlantModel' format
      return snapshot.docs.map((doc) {
        return PlantModel.fromFirestore(doc);
      }).toList();
    });
  }

  // 3. (Optional) Filter by Category
  // If you ever want to show ONLY 'Houseplants', you can use this
  Stream<List<PlantModel>> getPlantsByCategory(String category) {
    return _db
        .collection('plants')
        .where('category', isEqualTo: category) // Only get plants matching this category
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => PlantModel.fromFirestore(doc)).toList());
  }

  // دالة لجلب نباتات المستخدم الحالي فقط
  Stream<List<PlantModel>> getUserPlants(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('my_plants') // هذه هي المجموعة الفرعية الجديدة
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PlantModel.fromMap(doc.data(), doc.id))
        .toList());
  }


}