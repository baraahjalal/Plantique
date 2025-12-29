// lib/models/user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final List<String> favorites; // New field for favorite plant IDs

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.profileImageUrl,
    this.favorites = const [], // Default to empty list
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      // Logic to pull list of strings from Firebase
      favorites: List<String>.from(data['favorites'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'favorites': favorites,
    };
  }
}