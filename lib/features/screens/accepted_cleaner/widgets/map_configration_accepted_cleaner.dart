import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../utils/constants/colors.dart';

class MapConfigurationAcceptedCleaner extends StatelessWidget {
  const MapConfigurationAcceptedCleaner({
    super.key,
    required this.cleanerLocation,
    required this.clientLocation,
  });

  final LatLng cleanerLocation;
  final LatLng clientLocation;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options:
        MapOptions(initialCenter: cleanerLocation, initialZoom: 14.0),
        children: [
          TileLayer(
            urlTemplate:
            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
            additionalOptions: const {
              'attribute': '© OpenStreetMap contributors'
            },
          ),
          MarkerLayer(markers: [
            Marker(
                point: cleanerLocation,
                child: const Icon(
                  Icons.person_pin,
                  color: RColors.primary,
                  size: 40,
                )),
            Marker(
                point: clientLocation,
                child: const Icon(
                  Icons.house,
                  color: RColors.secondary,
                  size: 40,
                ))
          ])
        ]);
  }
}
