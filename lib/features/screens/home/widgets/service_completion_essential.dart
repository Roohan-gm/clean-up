import 'package:clean_up/features/controllers/order/order_controller.dart';
import 'package:clean_up/features/models/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:clean_up/features/controllers/services_cart/services_cart_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../available_cleaners/available_cleaner.dart';
import 'map_screen.dart';
import '../../../models/location_model.dart';

class ServiceCompletionEssential extends StatelessWidget {
  final ServicesCartController servicesCartController;

  ServiceCompletionEssential({
    super.key,
    required this.servicesCartController,
  });

  late final TextEditingController specialNoteController =
      TextEditingController(
    text: servicesCartController
        .specialNote.value, // Initialize with the stored value
  );

  bool isFormValid() {
    return servicesCartController.selectedLocation.value != null &&
        servicesCartController.specialNote.value.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: RColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: RColors.darkGrey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await Get.to(() => const MapScreen());
              if (result != null && result is Map<String, dynamic>) {
                servicesCartController.selectedLocation.value = LatLng(
                  result['latitude'],
                  result['longitude'],
                );
                servicesCartController.selectedAddress.value =
                    result['address'];

                for (var cartItem in servicesCartController.cartItems) {
                  cartItem.servicesLocation = LocationModel(
                    address: servicesCartController.selectedAddress.value,
                    latitude:
                        servicesCartController.selectedLocation.value!.latitude,
                    longitude: servicesCartController
                        .selectedLocation.value!.longitude,
                  );
                }
                servicesCartController.cartItems.refresh();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RColors.darkGrey,
              side: const BorderSide(color: RColors.darkGrey),
              foregroundColor: RColors.white,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  CupertinoIcons.search,
                  color: RColors.white,
                ),
                Text(
                  "Location of Service?",
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  CupertinoIcons.arrow_right,
                  color: RColors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            return servicesCartController.selectedAddress.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Selected Location: ${servicesCartController.selectedAddress.value}',
                      style: const TextStyle(
                        color: RColors.darkGrey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
          TextFormField(
            maxLines: 2,
            controller: specialNoteController,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Icon(CupertinoIcons.news),
              ),
              labelText: "Notes",
              labelStyle: TextStyle(color: RColors.darkGrey),
            ),
            onChanged: (note) {
              servicesCartController.specialNote.value = note;
            },
          ),
          const SizedBox(height: 10),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Cost:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RColors.darkGrey,
                  ),
                ),
                Text(
                  "Rs. ${servicesCartController.totalAmount.value.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RColors.darkGrey,
                  ),
                ),
              ],
            );
          }),
          const Divider(
            height: 20,
            thickness: 0.5,
            color: RColors.darkGrey,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!isFormValid()) {
                  Get.snackbar(
                    'Missing Details',
                    'Please provide both location and note to proceed.',
                    backgroundColor: RColors.primary,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 3),
                  );
                  return;
                }

                final newOrder = OrderModel(
                  status: 'pending',
                  cartItems: servicesCartController.cartItems,
                );

                final orderId =
                    await Get.find<OrderController>().addOrder(newOrder);

                // Clear the cart and related details
                servicesCartController.cartItems.clear();
                servicesCartController.specialNote.value = '';
                servicesCartController.selectedLocation.value = null;
                servicesCartController.selectedAddress.value = '';
                servicesCartController.totalAmount.value = 0.0; // Reset total amount

                Get.to(() => AvailableCleaner(orderId: orderId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: RColors.primary,
                foregroundColor: RColors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: const Text(
                "Find Cleaner",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
