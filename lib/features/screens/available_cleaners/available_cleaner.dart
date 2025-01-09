import 'package:clean_up/features/screens/accepted_cleaner/accepted_cleaner.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/constants/image_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailableCleaner extends StatelessWidget {
  final String? orderId;

  const AvailableCleaner({super.key, required this.orderId});

  Future<List<dynamic>> fetchOffers(String orderId) async {
    try {
      final response = await Supabase.instance.client
          .from('offer')
          .select(
              '*, cleaner:Users (username, avg_rating, profile_picture, id)')
          .eq('order_id', orderId)
          .eq('status', 'pending');

      return response as List<dynamic>;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching offers: $e");
      }
      throw Exception('Error fetching offers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text("Available Cleaners",
                    style: Theme.of(context).textTheme.headlineLarge)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FutureBuilder<List<dynamic>>(
                    future: fetchOffers(orderId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: RColors.primary,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No cleaners have made offers yet.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: RColors.grey),
                          ),
                        );
                      } else {
                        final offers = snapshot.data!;
                        return ListView.builder(
                          itemCount: offers.length,
                          // Replace with your actual item count.
                          itemBuilder: (BuildContext context, int index) {
                            final offer = offers[index];
                            final cleaner = offer['cleaner'];
                            return Card(
                              color: RColors.white,
                              elevation: 5,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    cleaner['profile_picture'] ?? RImages.user,
                                  ),
                                  maxRadius: 29,
                                ),
                                title: Text(
                                    cleaner['username'] ?? "Unknown Cleaner"),
                                subtitle: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      color: RColors.primary,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      cleaner['avg_rating']
                                              ?.toStringAsFixed(1) ??
                                          "0.0",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: RColors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "\$${offer['offer_amount']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: RColors.darkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${offer['arrival_time']} min",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: RColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 23,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                // Assume 'orderId' and 'offerId' are available for the selected cleaner.
                                                final String orderId = offer[
                                                    'order_id']; // Replace with the actual order ID.
                                                final String offerId = offer[
                                                    'id']; // Replace with the actual offer ID.

                                                // Update the offer and order status in Supabase
                                                final offerResponse =
                                                    await Supabase
                                                        .instance.client
                                                        .from('offer')
                                                        .update({
                                                  'status': 'accepted'
                                                }).eq('id', offerId);

                                                if (offerResponse == null) {
                                                  throw Exception(
                                                      offerResponse.message);
                                                }

                                                final orderResponse =
                                                    await Supabase
                                                        .instance.client
                                                        .from('order')
                                                        .update({
                                                  'status': 'in-progress'
                                                }).eq('id', orderId);

                                                if (orderResponse == null) {
                                                  throw Exception(
                                                      orderResponse.message);
                                                }

                                                // Navigate to the AcceptedCleaner screen
                                                Get.off(() =>
                                                    const AcceptedCleaner());
                                              } catch (e) {
                                                // Handle errors, e.g., show a snackbar or alert
                                                Get.snackbar(
                                                  'Error',
                                                  e.toString(),
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: RColors.white,
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              backgroundColor: RColors.primary,
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.center,
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: const Text(
                                              "Accept",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 23,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                // Assume 'offerId' is available for the selected offer
                                                final String offerId = offer[
                                                    'id']; // Replace with the actual offer ID.
                                                final String orderId = offer[
                                                    'order_id']; // Replace with the actual offer ID.

                                                // Update the offer's status to 'declined' in the Supabase database
                                                final response = await Supabase
                                                    .instance.client
                                                    .from('offer')
                                                    .update({
                                                  'status': 'rejected'
                                                }).eq('id', offerId);

                                                if (response.error != null) {
                                                  throw Exception(
                                                      response.error!.message);
                                                }

                                                fetchOffers(
                                                    orderId); // Call this if you're using FutureBuilder.
                                              } catch (e) {
                                                // Handle errors and show a message to the user
                                                Get.snackbar(
                                                  'Error',
                                                  'Failed to decline the offer: $e',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: RColors.white,
                                              backgroundColor:
                                                  RColors.secondary,
                                              padding: EdgeInsets.zero,
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              alignment: Alignment.center,
                                              elevation: 5,
                                              side: const BorderSide(
                                                  color: RColors.secondary),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: const Text(
                                              "Decline",
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
                      }
                    }),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: RColors.white,
                  backgroundColor: RColors.secondary,
                  alignment: Alignment.center,
                  side: const BorderSide(color: RColors.secondary),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "Cancel Order",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
