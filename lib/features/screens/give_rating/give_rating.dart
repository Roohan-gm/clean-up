import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/accepted_cleaner/accepted_cleaner_controller.dart';

class GiveRating extends StatelessWidget {
  const GiveRating({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AcceptedCleanerController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Obx(() {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Rate Your Cleaner",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CircleAvatar(
                    radius: screenWidth * 0.15,
                    backgroundImage:
                        controller.cleanerDetails['profile_picture'] != null
                            ? NetworkImage(
                                controller.cleanerDetails['profile_picture'])
                            : null,
                    child: controller.cleanerDetails['profile_picture'] == null
                        ? Icon(
                            Icons.person,
                            size: screenWidth * 0.15,
                            color: Colors.grey.shade600,
                          )
                        : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    controller.cleanerDetails['username'] ?? 'Cleaner Name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoColumn(
                        label: "Total",
                        value:
                            "Rs.${controller.offerDetails['offer_amount'] ?? 'N/A'}",
                      ),
                      _InfoColumn(
                        label: "Time",
                        value: "${controller.cleaningDuration.value} min",
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    "How would you rate the service?",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          controller.selectedStars.value = index + 1;
                        },
                        child: Icon(
                          index < controller.selectedStars.value
                              ? Icons.star
                              : Icons.star_border,
                          size: screenWidth * 0.1,
                          color: index < controller.selectedStars.value
                              ? RColors.primary
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextField(
                    controller: controller.commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Write your comment...",
                      labelStyle: const TextStyle(color: RColors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      contentPadding: EdgeInsets.all(screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submitRating,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 5,
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  }),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
