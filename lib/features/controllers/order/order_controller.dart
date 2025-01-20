import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/repositories/order/order_repositories.dart';
import '../../models/order_model.dart';


class OrderController extends GetxController {
  final OrderRepository _orderRepository;
  var orders = <OrderModel>[].obs;

  OrderController(this._orderRepository);

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      final fetchedOrders = await _orderRepository.fetchOrders();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch orders: $e');
      }
    }
  }

  Future<String?> addOrder(OrderModel order) async {
    try {
      final newOrder = await _orderRepository.addOrder(order);
      orders.add(newOrder);
      final orderId = newOrder.id;
      return orderId;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add order: $e');
      }
      return null;
    }
  }

  void updateOrderStatus(String orderId, String status) async {
    try {
      await _orderRepository.updateOrderStatus(orderId, status);
      final order = orders.firstWhere((order) => order.id == orderId);
      order.status = status;
      orders.refresh();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update order status: $e');
      }
    }
  }

  void deleteOrder(String orderId) async {
    try {
      await _orderRepository.deleteOrder(orderId);
      orders.removeWhere((order) => order.id == orderId);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete order: $e');
      }
    }
  }
}
