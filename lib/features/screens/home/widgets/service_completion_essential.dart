import 'package:clean_up/features/controllers/order/order_controller.dart';
import 'package:clean_up/features/models/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  const ServiceCompletionEssential({
    super.key,
    required this.servicesCartController,
  });

  @override
  Widget build(BuildContext context) {
    final specialNoteController = TextEditingController();
    final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
    final RxString selectedAddress = ''.obs;
    // final RxDouble totalPrice = 0.0.obs;

    // Calculate total price when the widget is built
    // servicesCartController.calculateTotalAmount().then((value) {
    //   totalPrice.value = value;
    // });

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
                selectedLocation.value = LatLng(
                  result['latitude'],
                  result['longitude'],
                );
                selectedAddress.value = result['address'];

                // Update the cart item's location directly
                for (var cartItem in servicesCartController.cartItems) {
                  cartItem.servicesLocation = LocationModel(
                    address: selectedAddress.value,
                    latitude: selectedLocation.value!.latitude,
                    longitude: selectedLocation.value!.longitude,
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
            return selectedAddress.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Selected Location: ${selectedAddress.value}',
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
              if (kDebugMode) {
                print(
                    'Updating note: $note for cart ID: ${servicesCartController.cartId.value}');
              }
              servicesCartController.updateCartItemSpecialNote(note);
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
                final newOrder = OrderModel(
                    status: 'pending',
                    cartItems: servicesCartController.cartItems);

                if (kDebugMode) {
                  print(
                      'Serialized cart_items: ${newOrder.toJson()['cart_items']}');
                }
                final orderId =
                    await Get.find<OrderController>().addOrder(newOrder);
                servicesCartController.clearCart();
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
