import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

class OfferMapConfiguration extends StatelessWidget {
  const OfferMapConfiguration({
    super.key,
    required this.cleanerLocation,
    required this.clientLocation,
  });

  final LatLng cleanerLocation;
  final LatLng clientLocation;

  @override
  Widget build(BuildContext context) {
    final cleanerLocationRx = Rx<LatLng>(cleanerLocation);
    final clientLocationRx = Rx<LatLng>(clientLocation);

    return Stack(
      children: [
        // Map configuration
        Obx(() {
          return FlutterMap(
            options: MapOptions(
              initialCenter: cleanerLocationRx.value,
              initialZoom: 14.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                additionalOptions: const {
                  'attribute': '© OpenStreetMap contributors',
                },
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [cleanerLocationRx.value, clientLocationRx.value],
                    color: RColors.primary,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  _buildMarker(
                    point: cleanerLocationRx.value,
                    icon: Icons.cleaning_services,
                    color: RColors.primary,
                    label: "Cleaner Location",
                  ),
                  _buildMarker(
                    point: clientLocationRx.value,
                    icon: Icons.location_on_rounded,
                    color: RColors.secondary,
                    label: "Client Location",
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

  // Helper to create custom markers
  Marker _buildMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Marker(
      point: point,
      width: 50,
      height: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
