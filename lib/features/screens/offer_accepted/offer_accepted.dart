import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';

import '../../../utils/constants/colors.dart';
import '../../controllers/offer/widget/offer_accepted_controller.dart';
import 'Widgets/client_contact_card.dart';
import 'Widgets/distance_cost_card.dart';
import 'Widgets/offer_map_configuration.dart';

class OfferAccepted extends StatelessWidget {
  const OfferAccepted({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final OfferAcceptedController controller =
        Get.find<OfferAcceptedController>();
    final offerDetails = box.read('orderDetails');
    if (kDebugMode) {
      print("customer_id: ${box.read('orderDetails')?['customer_id']}");
    }
    controller.listenForCustomerUpdates(offerDetails['orderId']);
    controller
        .subscribeToNotifications(box.read('orderDetails')?['customer_id']);

    final LatLng cleanerLocation = LatLng(
      offerDetails['cleanerLatitude'],
      offerDetails['cleanerLongitude'],
    );
    final LatLng clientLocation = LatLng(
      offerDetails['customerLatitude'],
      offerDetails['customerLongitude'],
    );

    return Scaffold(
      body: Stack(
        children: [
          // Map Section or Timer Section
          Obx(() {
            if (controller.showTimer.value) {
              return Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: 0,
                  right: 0,
                  child: _formatDuration(controller.cleaningDuration.value));
            } else if (controller.buttonState.value == "On My Way" ||
                controller.buttonState.value == "I Am Here") {
              return OfferMapConfiguration(
                cleanerLocation: cleanerLocation,
                clientLocation: clientLocation,
              );
            } else {
              return const SizedBox.shrink(); // Default empty widget
            }
          }),
          // Foreground Section
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              // Distance and Cost
              DistanceCostCard(
                distance: offerDetails['distance'],
                cost: offerDetails['offerAmount'].toString(),
              ),

              // Client Contact Card
              ClientContactCard(
                customerName: offerDetails['customerName'],
                customerPhone: offerDetails['customerPhone'],
                serviceDetails: offerDetails['services'],
                profileImageUrl: offerDetails['customerProfilePic'],
              ),

              allButtonOfferAccepted(
                controller: controller,
                offerDetails: offerDetails,
                showButton: controller.showButton.value,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Timer UI
  Widget _formatDuration(Duration cleaningDuration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(cleaningDuration.inHours);
    final minutes = twoDigits(cleaningDuration.inMinutes.remainder(60));
    final seconds = twoDigits(cleaningDuration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  // Timer Card
  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          elevation: 5,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          header,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Main Action Button
  Widget allButtonOfferAccepted(
      {required OfferAcceptedController controller,
      required Map offerDetails,
      required bool showButton}) {
    return Obx(() {
      // If `showButton` is false, hide the button
      if (!showButton) {
        return const SizedBox.shrink();
      }
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () async {
            await controller.toggleButton(offerDetails['orderId']);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: RColors.primary),
          child: Text(
            controller.buttonState.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    });
  }
}
