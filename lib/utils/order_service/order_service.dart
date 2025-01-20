
import 'package:geolocator/geolocator.dart'; // for distance calculation
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/models/order_model.dart';


class OrderService {
  final SupabaseClient supabaseClient;

  OrderService(this.supabaseClient);

  Future<List<OrderModel>> fetchOrdersWithinRange(LatLng location, double rangeKm) async {
    final response = await supabaseClient
        .from('orders')
        .select('id, user_id, status, cart_items(location)')
        .eq('status', 'Pending');
    final List<dynamic> orders = response;
    List<OrderModel> ordersInRange = [];

    for (var order in orders) {
      var orderLocation = order['cart_items'][0]['location'];
      LatLng orderLatLng = LatLng(orderLocation['latitude'], orderLocation['longitude']);
      double distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        orderLatLng.latitude,
        orderLatLng.longitude,
      ) / 1000; // Convert meters to km

      if (distance <= rangeKm) {
        ordersInRange.add(OrderModel.fromJson(order));
      }
    }
    return ordersInRange;
    }
}
