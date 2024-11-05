import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final DateTime? createdAt;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.createdAt,
  });

  // Factory method to create a ProfileModel from Firestore data
  factory ProfileModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProfileModel(
      id: documentId,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert ProfileModel to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
