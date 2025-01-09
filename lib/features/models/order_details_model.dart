import 'package:clean_up/features/models/service_model.dart';

import 'order_model.dart';

class OrderDetails {
  final String? id;
  final String customerName;
  final String customerProfilePic;
  final String address;
  final double totalPrice;
  final double distance;
  final List<ServicesModel> services;

  OrderDetails({
    required this.id,
    required this.customerName,
    required this.customerProfilePic,
    required this.address,
    required this.totalPrice,
    required this.distance,
    required this.services,
  });

  factory OrderDetails.fromOrderModel(OrderModel order, String customerName,
      String customerProfilePic, double distance) {
    final address = order.cartItems[0].servicesLocation?.address ?? "N/A";
    final totalPrice = order.cartItems.fold<double>(
      0.0,
      (sum, cartItem) => sum + cartItem.totalPrice,
    );
    final services =
        order.cartItems.expand((item) => item.servicesModel).toList();

    return OrderDetails(
      id: order.id,
      customerName: customerName,
      customerProfilePic: customerProfilePic,
      address: address,
      totalPrice: totalPrice,
      distance: distance,
      services: services,
    );
  }
}
