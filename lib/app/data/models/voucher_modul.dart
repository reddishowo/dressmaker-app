import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherModel {
  final String id;
  final String title;
  final String description;
  final String code;
  final double discount;
  final DateTime validUntil;
  final int maxClaims;
  final int currentClaims;
  final bool isActive;

  VoucherModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discount,
    required this.validUntil,
    required this.maxClaims,
    required this.currentClaims,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'code': code,
      'discount': discount,
      'validUntil': Timestamp.fromDate(validUntil),
      'maxClaims': maxClaims,
      'currentClaims': currentClaims,
      'isActive': isActive,
    };
  }

  factory VoucherModel.fromMap(Map<String, dynamic> map, String id) {
    return VoucherModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      code: map['code'] ?? '',
      discount: (map['discount'] ?? 0).toDouble(),
      validUntil: (map['validUntil'] as Timestamp).toDate(),
      maxClaims: map['maxClaims'] ?? 0,
      currentClaims: map['currentClaims'] ?? 0,
      isActive: map['isActive'] ?? false,
    );
  }
}