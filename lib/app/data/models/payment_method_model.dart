class PaymentMethodModel {
  String? id;
  String? name;
  double? fee;

  PaymentMethodModel({
    this.id,
    this.name,
    this.fee,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fee': fee,
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      name: json['name'],
      fee: json['fee']?.toDouble(),
    );
  }
}