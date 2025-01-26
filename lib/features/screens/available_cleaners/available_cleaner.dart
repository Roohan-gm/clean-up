import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/available_cleaner/available_cleaner_controller.dart';

class AvailableCleaner extends StatelessWidget {
  final String? orderId;

  const AvailableCleaner({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<AvailableCleanerController>(
        AvailableCleanerController(orderId!));

    // Screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Available Cleaners",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: RColors.primary,
                  ),
                );
              }

              if (controller.cleaners.isEmpty) {
                return const Center(
                  child: Text(
                    "No cleaners have made offers yet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: RColors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cleaners.length,
                itemBuilder: (context, index) {
                  final offer = controller.cleaners[index];
                  final cleaner = offer['cleaner'];

                  return Card(
                    elevation: 5,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Profile Picture
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  cleaner['profile_picture'] ?? RImages.user,
                                ),
                                radius: screenWidth * 0.08,
                              ),
                              const SizedBox(width: 15),
                              // Cleaner Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cleaner['username'] ?? "Unknown Cleaner",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: RColors.primary,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          cleaner['avg_rating']
                                                  ?.toStringAsFixed(1) ??
                                              "0.0",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Offer Amount
                              Text(
                                "Rs. ${offer['offer_amount']}",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: RColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () =>
                                    controller.rejectCleaner(offer['id']),
                                style: OutlinedButton.styleFrom(
                                  side:
                                      const BorderSide(color: RColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                ),
                                child: const Text(
                                  "Decline",
                                  style: TextStyle(
                                    color: RColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    controller.acceptCleaner(offer),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: RColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                ),
                                child: const Text(
                                  "Accept",
                                  style: TextStyle(
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
            }),
          ),
          // Cancel Order Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.cancelOrder(orderId!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RColors.secondary,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: BorderSide.none
                ),
                child: const Text(
                  "Cancel Order",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
