import 'package:clean_up/features/models/service_cart_model.dart';

class OrderModel {
  final String? id;
  final String? userId;
  final List<ServicesCartModel> cartItems;
  String status;

  OrderModel({
    required this.status,
    this.id,
    this.userId,
    required this.cartItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['customer_id'],
      cartItems: (json['services_cart'] as List)
          .map((item) => ServicesCartModel.fromJson(item))
          .toList(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'services_cart': cartItems.map((item) => item.toJson()).toList(),
      'status': status
    };
  }
}
