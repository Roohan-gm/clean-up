import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants/colors.dart';
import '../../controllers/order_history/order_history_controller.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderHistoryController controller = Get.put(OrderHistoryController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Offer History",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: RColors.primary,));
        }

        if (controller.offers.isEmpty) {
          return const Center(
            child: Text(
              "No offers available.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.offers.length,
              itemBuilder: (context, index) {
                final offer = controller.offers[index];

                // Format the created_at date
                final createdAt = offer['created_at'] != null
                    ? DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(offer['created_at']))
                    : 'Unknown';

                // Determine the color for the status text
                Color statusColor;
                switch (offer['status']) {
                  case 'accepted':
                    statusColor = RColors.primary;
                    break;
                  case 'rejected':
                    statusColor = Colors.red;
                    break;
                  default:
                    statusColor = Colors.grey;
                }

                return Card(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  elevation: 4,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    subtitleTextStyle: const TextStyle(color: RColors.secondary),
                    tileColor: RColors.white,
                    leading: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          createdAt.split(' – ')[0], // Date
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        Text(
                          createdAt.split(' – ')[1], // Time
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      "RS.${offer['offer_amount'] ?? 0}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    subtitle: Text(
                      "${offer['arrival_time'] ?? '0'} min",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      "${offer['status']?.toUpperCase() ?? 'PENDING'}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w900,
                        color: statusColor,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
