import 'dart:async'; // Import Timer

import 'package:clean_up/features/screens/accepted_cleaner/accepted_cleaner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailableCleanerController extends GetxController {
  var cleaners = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final SupabaseClient _db = Supabase.instance.client;

  Timer? _timer; // Add a timer reference
  final String orderId;

  AvailableCleanerController(this.orderId);

  @override
  void onInit() {
    super.onInit();
    startPeriodicFetch();
  }

  @override
  void onClose() {
    stopPeriodicFetch(); // Stop the timer when the controller is closed
    super.onClose();
  }

  void startPeriodicFetch() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchCleaners(orderId); // Fetch cleaners every 1 second
    });
  }

  void stopPeriodicFetch() {
    _timer?.cancel(); // Stop the periodic fetch
  }

  Future<void> fetchCleaners(String orderId) async {
    isLoading(true);
    try {
      final response = await _db.from('offer').select('''
      *,
      cleaner:Users (
        username, avg_rating, profile_picture, id, phone_number, current_location, total_rating
      ),
      order:order_id (
        services_cart
      )
    ''').eq('order_id', orderId).eq('status', 'pending');

      cleaners.value = response;
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptCleaner(Map<String, dynamic> offer) async {
    final box = GetStorage();
    try {
      if (offer['cleaner'] == null || offer.isEmpty) {
        throw 'Cleaner details or offer is missing.';
      }

      box.write('cleanerDetails', offer['cleaner']);
      box.write('offerDetails', offer);

      // Update the offer and order statuses
      await _db.from('offer').update({'status': 'accepted'}).eq('id', offer['id']);
      await _db.from('order').update({'status': 'in_progress'}).eq('id', offer['order_id']);

      Get.to(() => const AcceptedCleaner());
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }


  Future<void> rejectCleaner(String offerId) async {
    try {
      await Supabase.instance.client
          .from('offer')
          .update({'status': 'rejected'}).eq('id', offerId);

      // Refresh the list after rejecting
      fetchCleaners(orderId);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      // Update the order status to 'cancelled'
      await Supabase.instance.client
          .from('order')
          .update({'status': 'canceled'}).eq('id', orderId);

      // Optionally clear cleaners or navigate back
      cleaners.clear();
      Get.back(); // Go back to the previous screen
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}
