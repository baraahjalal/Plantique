import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // This function adds or removes the plant ID from the user's "favorites" list
  Future<void> toggleFavorite(String uid, String plantId) async {
    DocumentReference userRef = _db.collection('users').doc(uid);
    DocumentSnapshot userDoc = await userRef.get();

    // If the user document doesn't exist yet, create it with an empty favorites list
    if (!userDoc.exists) {
      await userRef.set({
        'uid': uid,
        'favorites': [plantId],
      });
      return;
    }

    // Check if the plant is already in the favorites list
    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
    List<dynamic> favorites = data['favorites'] ?? [];

    if (favorites.contains(plantId)) {
      // It's already there? REMOVE it
      await userRef.update({
        'favorites': FieldValue.arrayRemove([plantId])
      });
    } else {
      // It's not there? ADD it
      await userRef.update({
        'favorites': FieldValue.arrayUnion([plantId])
      });
    }
  }

  // This listens for any changes in the user's document (like adding a favorite)
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }
}