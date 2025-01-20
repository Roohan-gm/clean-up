import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/models/order_model.dart';

class OrderRepository {
  final SupabaseClient supabaseClient;

  OrderRepository(this.supabaseClient);

  /// Fetch all orders from the 'orders' table
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final response = await supabaseClient.from('orders').select();
      final List<dynamic> data = response;
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Error fetching orders: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Add a new order to the 'orders' table
  Future<OrderModel> addOrder(OrderModel order) async {
    final data = order.toJson();
    if (kDebugMode) {
      print('Inserting data: $data');
    } // Debugging
    try {
      final response = await supabaseClient
          .from('order')
          .insert(data)
          .select()
          .single();
      return OrderModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (kDebugMode) {
        print('PostgrestException: ${e.toString()}');
      } // Log detailed error
      if (kDebugMode) {
        print('Response error code: ${e.code}');
      }
      if (kDebugMode) {
        print('Response message: ${e.message}');
      }
      throw Exception('Error adding order: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      } // Catch other unexpected errors
      throw Exception('Unexpected error: $e');
    }
  }


  /// Update the status of an order in the 'orders' table
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await supabaseClient
          .from('orders')
          .update({'status': status})
          .eq('id', orderId);
    } on PostgrestException catch (e) {
      throw Exception('Error updating order status: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Delete an order from the 'orders' table
  Future<void> deleteOrder(String orderId) async {
    try {
      await supabaseClient.from('orders').delete().eq('id', orderId);
    } on PostgrestException catch (e) {
      throw Exception('Error deleting order: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
