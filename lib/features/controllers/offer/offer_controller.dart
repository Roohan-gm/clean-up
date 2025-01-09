import 'package:clean_up/features/controllers/offer/widget/fetch_nearby_orders.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order_details_model.dart';
import '../user/user_controller.dart';

final supabaseClient = Supabase.instance.client;
final userController = UserController.instance;

// OfferController
class OfferController extends GetxController {
  var isOnline = false.obs;
  var hasOffers = false.obs;
  var offers = <OrderDetails>[].obs;
  var isLoading = false.obs;
  var currentLocation = Rxn<Position>(); // To store the user's location
  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation(); // Fetch location when the controller is initialized
  }

  void fetchCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation.value = position;
    } catch (e) {
      Get.snackbar("Error", "Failed to get location: $e");
    }
  }

  Future<void> toggleOnlineStatus() async {
    isOnline.value = !isOnline.value;

    // Log the current user id
    if (kDebugMode) {
      print('Current User ID: ${userController.user.value.id}');
    }
    // Update the database with the new online status
    try {
      await Supabase.instance.client.from('Users').update(
          {'is_active': isOnline.value}).eq('id', userController.user.value.id);
    } catch (e) {
      // Handle any exceptions
      if (kDebugMode) {
        print('Exception updating is_active: $e');
      }
      // Optionally revert the toggle if an exception occurs
      isOnline.value = !isOnline.value;
    }
    if (isOnline.value) {
      fetchOffers();
    } else {
      offers.clear();
      hasOffers.value = false;
    }
  }

  void fetchOffers() async {
    if (currentLocation.value == null) {
      Get.snackbar("Error", "Unable to determine current location.");
      return;
    }

    isLoading.value = true;
    try {
      final orders = await fetchNearbyOrderDetails(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
        radius: 15.0,
      );
      offers.assignAll(orders);
      hasOffers.value = orders.isNotEmpty;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch offers: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToOfferDetails(OrderDetails orderDetails) {
    Get.toNamed('/offerDetails', arguments: orderDetails);
  }
}
