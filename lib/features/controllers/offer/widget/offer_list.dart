import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/colors.dart';
import '../../../models/order_details_model.dart';
import 'fetch_nearby_orders.dart';
import 'offer_accepted_controller.dart';

class OfferList extends StatelessWidget {
  final double cleanerLatitude;
  final double cleanerLongitude;
  final box = GetStorage();

  OfferList({
    super.key,
    required this.cleanerLatitude,
    required this.cleanerLongitude,
  });

  @override
  Widget build(BuildContext context) {
    final OfferAcceptedController controller = Get.find();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<OrderDetails>>(
              future: fetchNearbyOrderDetails(
                cleanerLatitude,
                cleanerLongitude,
                radius: 15.0,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: RColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: RColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No nearby orders available.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: RColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final orders = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      color: Colors.lightBlue[50],
                      // Updated to match theme
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Customer Profile Picture
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    order.customerProfilePic,
                                  ),
                                  radius: screenWidth * 0.08,
                                ),
                                const SizedBox(width: 15),
                                // Customer Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.customerName,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${order.distance.toStringAsFixed(2)} km",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Total Price
                                Text(
                                  "Rs.${order.totalPrice}",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: RColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Address, Services, and Modify Offer Button
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.address,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        order.services
                                            .map((s) =>
                                                '${s.name} (${s.quantity})')
                                            .join(", "),
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton(
                                  onPressed: () =>
                                      _modifyOffer(controller, order),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: RColors.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    "Modify Offer",
                                    style: TextStyle(
                                      color: RColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _modifyOffer(OfferAcceptedController controller, OrderDetails order) {
    double offerAmount = 0;
    int arrivalTime = 0;

    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit, color: RColors.primary),
            SizedBox(width: 8),
            Text(
              "Modify Offer",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              _buildInputField(
                labelText: "Offer Amount (Rs.)",
                hintText: "Enter offer amount",
                icon: Icons.monetization_on_outlined,
                onChanged: (value) =>
                    offerAmount = double.tryParse(value) ?? offerAmount,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                labelText: "Arrival Time (minutes)",
                hintText: "Enter arrival time",
                icon: Icons.timer_outlined,
                onChanged: (value) =>
                    arrivalTime = int.tryParse(value) ?? arrivalTime,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: RColors.darkGrey,
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (offerAmount > 0 && arrivalTime > 0) {
                controller.submitOffer(
                  orderId: order.id!,
                  customerName: order.customerName,
                  offerAmount: offerAmount,
                  arrivalTime: arrivalTime,
                );
                final orderDetails = {
                  'customerProfilePic': order.customerProfilePic,
                  'cleanerLatitude': cleanerLatitude,
                  'cleanerLongitude': cleanerLongitude,
                  'services': order.services,
                  'customerLatitude': order.serviceLocation.latitude,
                  'customerLongitude': order.serviceLocation.longitude,
                  'customerName': order.customerName,
                  'customerPhone': order.customerPhone,
                  'distance': order.distance,
                  'offerAmount': offerAmount,
                  'orderId': order.id!,
                  'customer_id': order.customerId
                };

                // Store the Map in GetStorage
                box.write('orderDetails', orderDetails);

                Get.back();
              } else {
                Get.snackbar(
                  "Invalid Input",
                  "Please enter valid values for both fields.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: RColors.error.withOpacity(0.8),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 8,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Submit",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String labelText,
    required String hintText,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: RColors.primary),
        labelStyle: const TextStyle(color: RColors.darkGrey, fontSize: 14),
        hintStyle: const TextStyle(color: RColors.lightGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: RColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: RColors.lightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      onChanged: onChanged,
    );
  }
}
