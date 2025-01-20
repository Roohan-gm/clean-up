import 'package:clean_up/features/controllers/offer/widget/offer_accepted_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitingForResponseScreen extends StatelessWidget {
  final String customerName;
  final String offerId;

  const WaitingForResponseScreen(
      {super.key, required this.customerName, required this.offerId});

  @override
  Widget build(BuildContext context) {
    final OfferAcceptedController controller = Get.find();
    controller.listenForOfferUpdates(offerId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Waiting for Response"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_top, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              "Offer submitted to $customerName",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text("Waiting for the customer's response..."),
          ],
        ),
      ),
    );
  }
}
