import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/location_model.dart';
import '../../../models/order_details_model.dart';
import '../../../models/order_model.dart';

final supabaseClient = Supabase.instance.client;

Future<List<OrderDetails>> fetchNearbyOrderDetails(
    double cleanerLatitude, double cleanerLongitude,
    {required double radius}) async {
  try {
    if (kDebugMode) {
      print("Fetching nearby orders...");
    }
    if (kDebugMode) {
      print("Inputs: cleanerLatitude: $cleanerLatitude, cleanerLongitude: $cleanerLongitude, radius: $radius");
    }

    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No authenticated user found.');
    }

    if (kDebugMode) {
      print("Authenticated user ID: $userId");
    }

    final response = await supabaseClient.rpc('find_nearby_orders', params: {
      'cleaner_lat': cleanerLatitude,
      'cleaner_long': cleanerLongitude,
      'radius_km': radius,
      'cleaner_id': userId,
    });

    if (kDebugMode) {
      print("Raw response from RPC: $response");
    }

    if (kDebugMode) {
      print("RPC call completed. Response: $response");
    }

    if (response == null) {
      if (kDebugMode) {
        print("RPC response is null.");
      }
      throw Exception('RPC response is null');
    }

    if (response is List<dynamic>) {
      if (response.isEmpty) {
        if (kDebugMode) {
          print("No nearby orders found.");
        }
        return [];
      }

      if (kDebugMode) {
        print("Orders received: ${response.length}");
      }
      final orders = List<Map<String, dynamic>>.from(response);

      return orders.map((orderJson) {
        final order = OrderModel.fromJson(orderJson);
        final serviceLocationJson = orderJson['location'] as Map<String, dynamic>?;
        final serviceLocation = serviceLocationJson != null
            ? LocationModel.fromJson(serviceLocationJson)
            : LocationModel(latitude: 0.0, longitude: 0.0, address: 'N/A'); // Provide default location

        return OrderDetails.fromOrderModel(
          order,
          orderJson['customer_name'] ?? 'Unknown Customer',
          orderJson['customer_profile_pic'] ?? '',
          (orderJson['distance_km'] ?? 0).toDouble(),
          orderJson['customer_phone'] ?? 'Unknown Phone',
          serviceLocation,
          customerId: orderJson['customer_id'],
        );
      }).toList();
    } else {
      if (kDebugMode) {
        print("Unexpected response type: ${response.runtimeType}");
      }
      throw Exception('Unexpected response type: ${response.runtimeType}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error in fetchNearbyOrderDetails: $e");
    }
    throw Exception('Error fetching nearby orders: $e');
  }
}
