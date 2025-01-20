import 'package:clean_up/features/models/service_model.dart';

import 'location_model.dart';
import 'order_model.dart';

class OrderDetails {
  final String? id;
  final String customerName;
  final String customerProfilePic;
  final String address;
  final double totalPrice;
  final double distance;
  final String customerPhone;
  final List<ServicesModel> services;
  final LocationModel serviceLocation;

  OrderDetails({
    required this.id,
    required this.customerName,
    required this.customerProfilePic,
    required this.address,
    required this.totalPrice,
    required this.distance,
    required this.customerPhone,
    required this.serviceLocation,
    required this.services,
  });

  factory OrderDetails.fromOrderModel(
      OrderModel order,
      String customerName,
      String customerProfilePic,
      double distance,
      String customerPhone,
      LocationModel serviceLocation,
      ) {
    final address = order.cartItems.isNotEmpty
        ? order.cartItems[0].servicesLocation?.address ?? "N/A"
        : "N/A";
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
      customerPhone: customerPhone,
      serviceLocation: serviceLocation,
      services: services,
    );
  }
}
