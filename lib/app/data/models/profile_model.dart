import 'package:cloud_firestore/cloud_firestore.dart';

// In profile_model.dart
class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final DateTime? createdAt;
  final String role; // Add this field

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.createdAt,
    required this.role, // Add this parameter
  });

  factory ProfileModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProfileModel(
      id: documentId,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      role: data['role'] ?? 'user', // Default to 'user' if not specified
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'role': role,
    };
  }
}