import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';

class AcceptedCleanerController extends GetxController {
  late Map<String, dynamic> cleanerDetails;
  late Map<String, dynamic> offerDetails;
  late List<dynamic> servicesCart;

  // Reactive variables for cleaner and client locations
  final cleanerLocation = LatLng(0, 0).obs;
  final clientLocation = LatLng(0, 0).obs;

  @override
  void onInit() {
    super.onInit();
    final storage = GetStorage();

    // Retrieve data from GetStorage
    cleanerDetails = storage.read('cleanerDetails') ?? {};
    offerDetails = storage.read('offerDetails') ?? {};

    // Handle missing or incomplete data
    if (cleanerDetails.isEmpty || offerDetails.isEmpty) {
      Get.snackbar(
        'Error',
        'Required data is missing. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    // Extract services_cart data from offer details
    servicesCart = offerDetails['order']['services_cart'];

    // Initialize locations
    cleanerLocation.value = LatLng(
      cleanerDetails['current_location']['latitude'],
      cleanerDetails['current_location']['longitude'],
    );
    clientLocation.value = LatLng(
      servicesCart[0]['location']['latitude'], // From the first service_cart
      servicesCart[0]['location']['longitude'],
    );
  }

  @override
  void onClose() {
    super.onClose();

    // Reset reactive variables
    cleanerLocation.value = LatLng(0, 0);
    clientLocation.value = LatLng(0, 0);

    // Clear non-reactive variables
    cleanerDetails.clear();
    offerDetails.clear();
    servicesCart.clear();

    // Optional: Clear stored data if not needed
    final storage = GetStorage();
    storage.remove('cleanerDetails');
    storage.remove('offerDetails');
  }
}
