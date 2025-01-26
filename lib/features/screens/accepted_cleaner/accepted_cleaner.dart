import 'package:clean_up/features/screens/accepted_cleaner/widgets/cleaner_info_contact.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/map_configration_accepted_cleaner.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/service_cost_card.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/accepted_cleaner/accepted_cleaner_controller.dart';

class AcceptedCleaner extends StatelessWidget {
  const AcceptedCleaner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AcceptedCleanerController());

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map Section
            Obx(() {
              return MapConfigurationAcceptedCleaner(
                cleanerLocation: controller.cleanerLocation.value,
                clientLocation: controller.clientLocation.value,
              );
            }),

            // Bottom Card Section
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                // Service Cost Card
                ServiceCostCard(
                  servicesCart: controller.servicesCart,
                  cost: controller.offerDetails['offer_amount'].toString(),
                ),
                // Cleaner Info Card
                CleanerInfoContactCard(
                  cleanerName: controller.cleanerDetails['username'],
                  avgRating:
                  (controller.cleanerDetails['avg_rating'] ?? 0)
                      .toDouble(),
                  totalRatings: controller.cleanerDetails['total_rating'] ?? 0,
                  profilePicture:
                  controller.cleanerDetails['profile_picture'] ?? '',
                  phoneNumber:
                  controller.cleanerDetails['phone_number'] ?? '',
                ),

                // Action Button
                Obx(() {
                  return _buildActionButton(
                    context: context,
                    buttonText: controller.buttonState.value,
                    onPressed: () async {
                      await controller.toggleButton(
                          controller.offerDetails['order_id']);
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the action button based on the current state
  Widget _buildActionButton({
    required BuildContext context,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: RColors.primary,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
