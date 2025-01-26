import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/accepted_cleaner/accepted_cleaner_controller.dart';
import '../accepted_cleaner/widgets/cleaner_info_contact.dart';
import '../accepted_cleaner/widgets/service_cost_card.dart';

class StartCleaning extends StatelessWidget {
  const StartCleaning({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<AcceptedCleanerController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            CircularProgressIndicator(
              color: RColors.white,
              strokeWidth: screenWidth * 0.01,
            ),

            SizedBox(height: screenHeight * 0.1),
            Text(
              "Cleaning in Progress...",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: RColors.white,
              ),
            ),

            const Spacer(),
            ServiceCostCard(
              servicesCart: controller.servicesCart,
              cost: controller.offerDetails['offer_amount']
                  .toString(),
            ),
            CleanerInfoContactCard(
              cleanerName: controller.cleanerDetails['username'],
              avgRating: controller.cleanerDetails['avg_rating']
                  .toDouble(),
              totalRatings: controller.cleanerDetails['total_rating'],
              profilePicture:
              controller.cleanerDetails['profile_picture'],
              phoneNumber: controller.cleanerDetails['phone_number'],
            ),
            SizedBox(height: screenHeight * 0.01)
          ],
        ),
      ),
    );
  }
}
