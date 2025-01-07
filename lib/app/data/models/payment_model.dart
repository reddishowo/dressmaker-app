class PaymentModel {
  String? id;
  String? method;
  double? amount;
  String? status;
  DateTime? createdAt;

  PaymentModel({
    this.id,
    this.method,
    this.amount,
    this.status,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method,
      'amount': amount,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      method: json['method'],
      amount: json['amount']?.toDouble(),
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}