import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String text;
  final DateTime createdAt;
  final String? adminResponse;
  final DateTime? respondedAt;
  final String? userName;
  final String? userEmail;
  final String? userImage;
  final String? category;
  final int? rating;
  final bool isResolved;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.adminResponse,
    this.respondedAt,
    this.userName,
    this.userEmail,
    this.userImage,
    this.category,
    this.rating,
    this.isResolved = false,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    final createdAtTimestamp = json['createdAt'];
    final respondedAtTimestamp = json['respondedAt'];

    return FeedbackModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? 'anonymous',
      text: json['text'] ?? '',
      createdAt: createdAtTimestamp is Timestamp 
          ? createdAtTimestamp.toDate() 
          : DateTime.now(),
      adminResponse: json['adminResponse'],
      respondedAt: respondedAtTimestamp is Timestamp 
          ? respondedAtTimestamp.toDate() 
          : null,
      userName: json['userName'],
      userEmail: json['userEmail'],
      userImage: json['userImage'],
      category: json['category'],
      rating: json['rating'],
      isResolved: json['isResolved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'text': text,
        'createdAt': Timestamp.fromDate(createdAt),
        'adminResponse': adminResponse,
        'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
        'userName': userName,
        'userEmail': userEmail,
        'userImage': userImage,
        'category': category,
        'rating': rating,
        'isResolved': isResolved,
      };

  FeedbackModel copyWith({
    String? id,
    String? userId,
    String? text,
    DateTime? createdAt,
    String? adminResponse,
    DateTime? respondedAt,
    String? userName,
    String? userEmail,
    String? userImage,
    String? category,
    int? rating,
    bool? isResolved,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      adminResponse: adminResponse ?? this.adminResponse,
      respondedAt: respondedAt ?? this.respondedAt,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImage: userImage ?? this.userImage,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isResolved: isResolved ?? this.isResolved,
    );
  }

  @override
  String toString() {
    return 'FeedbackModel(id: $id, userId: $userId, text: $text, createdAt: $createdAt, '
           'adminResponse: $adminResponse, respondedAt: $respondedAt, userName: $userName, '
           'userEmail: $userEmail, category: $category, rating: $rating, isResolved: $isResolved)';
  }
}