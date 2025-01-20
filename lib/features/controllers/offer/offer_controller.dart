import 'package:clean_up/features/controllers/offer/widget/fetch_nearby_orders.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
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
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled. Please enable them.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            "Location permissions are permanently denied. Please enable them in settings.");
      }

      // Fetch coordinates
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation.value = position;

      // Reverse geocoding to fetch the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        String address =
            "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        Get.snackbar("Location Found", "Address: $address");

        // Update the location in the database, including the address
        await updateCurrentLocationInDatabase(
            position.latitude, position.longitude, address);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get location: $e");
    }
  }

  Future<void> updateCurrentLocationInDatabase(
      double latitude, double longitude, String address) async {
    try {
      await Supabase.instance.client.from('Users').update({
        'current_location': {
          'latitude': latitude,
          'longitude': longitude,
          'address': address, // Add the address
        }
      }).eq('id', userController.user.value.id);

      if (kDebugMode) {
        print('Updated location and address in database successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating location in database: $e');
      }
      Get.snackbar("Error", "Failed to update location in database.");
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
