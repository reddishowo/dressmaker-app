
import 'package:cloud_firestore/cloud_firestore.dart';

class MeasurementModel {
  final String id;
  final String userId;
  final double shoulderWidth;      // Lebar bahu
  final double chest;              // Lingkar dada
  final double waist;              // Lingkar pinggang
  final double hip;                // Lingkar pinggul
  final double sleeveLength;       // Panjang lengan
  final double armCircumference;   // Lingkar lengan
  final double bodyLength;         // Panjang badan
  final double neckCircumference;  // Lingkar leher
  final DateTime lastUpdated;
  
  MeasurementModel({
    required this.id,
    required this.userId,
    required this.shoulderWidth,
    required this.chest,
    required this.waist,
    required this.hip,
    required this.sleeveLength,
    required this.armCircumference,
    required this.bodyLength,
    required this.neckCircumference,
    required this.lastUpdated,
  });

  factory MeasurementModel.fromMap(Map<String, dynamic> data, String documentId) {
    return MeasurementModel(
      id: documentId,
      userId: data['userId'] ?? '',
      shoulderWidth: (data['shoulderWidth'] ?? 0).toDouble(),
      chest: (data['chest'] ?? 0).toDouble(),
      waist: (data['waist'] ?? 0).toDouble(),
      hip: (data['hip'] ?? 0).toDouble(),
      sleeveLength: (data['sleeveLength'] ?? 0).toDouble(),
      armCircumference: (data['armCircumference'] ?? 0).toDouble(),
      bodyLength: (data['bodyLength'] ?? 0).toDouble(),
      neckCircumference: (data['neckCircumference'] ?? 0).toDouble(),
      lastUpdated: data['lastUpdated'] != null 
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'shoulderWidth': shoulderWidth,
      'chest': chest,
      'waist': waist,
      'hip': hip,
      'sleeveLength': sleeveLength,
      'armCircumference': armCircumference,
      'bodyLength': bodyLength,
      'neckCircumference': neckCircumference,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
