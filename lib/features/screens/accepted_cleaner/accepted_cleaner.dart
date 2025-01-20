import 'package:clean_up/features/screens/accepted_cleaner/widgets/cancel_button.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/cleaner_info_contact.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/map_configration_accepted_cleaner.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/service_cost_card.dart';
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
              // Ensure cleanerLocation and clientLocation are Rx variables
              return MapConfigurationAcceptedCleaner(
                cleanerLocation: controller.cleanerLocation.value,
                clientLocation: controller.clientLocation.value,
              );
            }),

            // UI Overlay Section
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CancelButton(),
                  ),
                ),

                // Bottom Card Section
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ServiceCostCard(
                      servicesCart: controller.servicesCart,
                      cost: controller.offerDetails['offer_amount']
                          .toString(),
                    ),
                    const SizedBox(height: 10),
                    CleanerInfoContactCard(
                      cleanerName: controller.cleanerDetails['username'],
                      avgRating: controller.cleanerDetails['avg_rating']
                          .toDouble(),
                      totalRatings: controller.cleanerDetails['total_rating'],
                      profilePicture:
                      controller.cleanerDetails['profile_picture'],
                      phoneNumber: controller.cleanerDetails['phone_number'],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
