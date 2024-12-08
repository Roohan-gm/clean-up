import 'package:clean_up/features/screens/accepted_cleaner/widgets/cancel_button.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/cleaner_info_contact_contact.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/map_configration_accepted_cleaner.dart';
import 'package:clean_up/features/screens/accepted_cleaner/widgets/service_cost_card.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AcceptedCleaner extends StatefulWidget {
  const AcceptedCleaner({super.key});

  @override
  State<AcceptedCleaner> createState() => _AcceptedCleanerState();
}

class _AcceptedCleanerState extends State<AcceptedCleaner> {
  // Map-related variables
  final LatLng cleanerLocation =
      const LatLng(37.42796133580664, -122.085749655962);
  final LatLng clientLocation =
      const LatLng(37.43066233580664, -122.086749655962);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map Section

            MapConfigurationAcceptedCleaner(
              cleanerLocation: cleanerLocation,
              clientLocation: clientLocation,
            ),

            // UI Overlay Section
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button at the top
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: CancelButton(),
                ),

                // Bottom Card Section
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ServiceCostCard(),
                    SizedBox(height: 10),
                    CleanerInfoContactCard(),
                    SizedBox(height: 10),
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
