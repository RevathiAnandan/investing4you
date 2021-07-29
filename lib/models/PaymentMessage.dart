class PaymentMessage {
  bool success;
  String data;
  String message;

  PaymentMessage({this.success, this.data, this.message});

  factory PaymentMessage.fromJson(dynamic json) {
    return PaymentMessage(
      success: json['success'] as bool ?? false,
      data: json['data'] as String ?? "",
      message: json['message'] as String ?? "",
    );
  }
}
