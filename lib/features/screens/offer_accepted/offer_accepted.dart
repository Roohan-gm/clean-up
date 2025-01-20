import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';

import '../../../navigation_menu.dart';
import '../../controllers/offer/widget/offer_accepted_controller.dart';
import 'Widgets/cancel_offer_button.dart';
import 'Widgets/client_contact_card.dart';
import 'Widgets/distance_cost_card.dart';
import 'Widgets/offer_map_configuration.dart';


class OfferAccepted extends StatelessWidget {
  const OfferAccepted({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final OfferAcceptedController controller = Get.find();
    final offerDetails = box.read('orderDetails');

    final LatLng cleanerLocation = LatLng(
      offerDetails['cleanerLatitude'],
      offerDetails['cleanerLongitude'],
    );
    final LatLng clientLocation = LatLng(
      offerDetails['customerLatitude'],
      offerDetails['customerLongitude'],
    );

    final String buttonState = controller.buttonState.value;
    final bool showTimer = controller.showTimer.value;
    final Duration cleaningDuration = controller.cleaningDuration.value;
    final bool showConfirmationButtons = controller.showConfirmationButtons.value;

    return Scaffold(
      body: Stack(
        children: [
          // Map Section
          if (buttonState == "On My Way" || buttonState == "I Am Here")
            OfferMapConfiguration(
              cleanerLocation: cleanerLocation,
              clientLocation: clientLocation,
            ),

          // Timer Section
          if (showTimer)
            Center(
              child: _formatDuration(cleaningDuration),
            ),

          // Foreground Section
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section
              if (buttonState == "On My Way" || buttonState == "I Am Here")
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: CancelOfferButton(),
                )
              else
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              // Bottom Cards
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Distance and Cost
                  DistanceCostCard(
                    distance: offerDetails['distance'],
                    cost: offerDetails['offerAmount'].toString(),
                  ),

                  const SizedBox(height: 10),

                  // Client Contact Card
                  ClientContactCard(
                    customerName: offerDetails['customerName'],
                    customerPhone: offerDetails['customerPhone'],
                    serviceDetails: offerDetails['services'],
                    profileImageUrl: offerDetails['customerProfilePic'],
                  ),

                  const SizedBox(height: 10),

                  // Confirmation Buttons
                  if (showConfirmationButtons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        yesButton(controller),
                        noButton(controller),
                      ],
                    )
                  else
                    allButtonOfferAccepted(controller, offerDetails),
                ],
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
  Widget allButtonOfferAccepted(OfferAcceptedController controller, Map offerDetails) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: () async {
          await controller.toggleButton(offerDetails['orderId']);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: controller.buttonState.value == "On My Way"
              ? Colors.blueAccent
              : controller.buttonState.value == "Start Cleaning"
              ? Colors.green
              : Colors.orange,
        ),
        child: Text(
          controller.buttonState.value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Yes Button
  Widget yesButton(OfferAcceptedController controller) {
    return ElevatedButton(
      onPressed: () {
        controller.confirmCleaning(true);
        Get.off(() => const NavigationMenu());
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        backgroundColor: Colors.green,
      ),
      child: const Text(
        "Yes",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // No Button
  Widget noButton(OfferAcceptedController controller) {
    return ElevatedButton(
      onPressed: () {
        controller.confirmCleaning(false);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        backgroundColor: Colors.red,
      ),
      child: const Text(
        "No",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
