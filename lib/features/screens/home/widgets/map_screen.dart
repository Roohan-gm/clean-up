import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/service_location_map/service_location_map_controller.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapScreenController = Get.find<MapScreenController>();

    return Scaffold(
      body: Stack(
        children: [
          // Map with layers and markers
          FlutterMap(
            mapController: mapScreenController.mapController,
            options: MapOptions(
              initialZoom: 13.0,
              onTap: (tapPosition, latlng) {
                mapScreenController.selectedPosition.value = latlng;
                mapScreenController.draggedPosition.value = latlng;
                mapScreenController.addSelectedMarker(latlng);
              },
            ),
            children: [
              // Tile Layer (map tiles)
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              // Static Markers
              MarkerLayer(
                markers: mapScreenController.markers,
              ),
              // Dragging Marker
              Obx(() {
                if (mapScreenController.isDragging.value &&
                    mapScreenController.draggedPosition.value != null) {
                  return MarkerLayer(
                    markers: [
                      Marker(
                        point: mapScreenController.draggedPosition.value!,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          CupertinoIcons.largecircle_fill_circle,
                          color: RColors.primary,
                          size: 35,
                        ),
                      ),
                    ],
                  );
                }
                return const MarkerLayer(markers: []);
              }),
              // User's Current Location Marker
              Obx(() {
                if (mapScreenController.myLocation.value != null) {
                  return MarkerLayer(
                    markers: [
                      Marker(
                        point: mapScreenController.myLocation.value!,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_on,
                          color: RColors.primary,
                          size: 40,
                        ),
                      ),
                    ],
                  );
                }
                return const MarkerLayer(markers: []);
              }),
            ],
          ),

          // Back Button with Address Fetching
          Positioned(
            top: 40,
            left: 15,
            child: Container(
              height: 55,
              decoration: const BoxDecoration(
                color: RColors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 4)),
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  final selectedPosition = mapScreenController.selectedPosition.value;
                  if (selectedPosition != null) {
                    try {
                      final address = await mapScreenController.getAddressFromLatLng(
                        selectedPosition.latitude,
                        selectedPosition.longitude,
                      );
                      Get.back(result: {
                        'latitude': selectedPosition.latitude,
                        'longitude': selectedPosition.longitude,
                        'address': address,
                      });
                    } catch (e) {
                      Get.snackbar("Error", "Failed to fetch address: $e");
                    }
                  } else {
                    Get.back();
                  }
                },
                icon: const Icon(
                  CupertinoIcons.arrow_left,
                  size: 30,
                  color: RColors.darkGrey,
                ),
              ),
            ),
          ),

          // Search Bar and Results
          Positioned(
            top: 40,
            left: 80,
            right: 15,
            child: Column(
              children: [
                // Search TextField
                SizedBox(
                  height: 55,
                  child: TextField(
                    controller: mapScreenController.searchController,
                    decoration: InputDecoration(
                      hintText: "Search for a location...",
                      filled: true,
                      fillColor: RColors.white,
                      hintStyle: const TextStyle(fontSize: 18, color: RColors.darkGrey),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(CupertinoIcons.search),
                      suffixIcon: mapScreenController.isSearching.value
                          ? IconButton(
                        onPressed: () {
                          mapScreenController.searchController.clear();
                          mapScreenController.isSearching.value = false;
                          mapScreenController.searchResults.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                          : null,
                    ),
                    onTap: () {
                      mapScreenController.isSearching.value = true;
                    },
                  ),
                ),
                // Search Results
                Obx(() {
                  if (mapScreenController.isSearching.value &&
                      mapScreenController.searchResults.isNotEmpty) {
                    return Container(
                      color: RColors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: mapScreenController.searchResults.length,
                        itemBuilder: (ctx, index) {
                          final place = mapScreenController.searchResults[index];
                          return ListTile(
                            title: Text(place['display_name']),
                            onTap: () {
                              final lat = double.parse(place['lat']);
                              final lon = double.parse(place['lon']);
                              mapScreenController.moveToLocation(lat, lon);
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),

          // Show Current Location Button with animation
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: RColors.primary,
              foregroundColor: RColors.white,
              onPressed: mapScreenController.showCurrentLocation,
              child: const Icon(Icons.location_searching_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
