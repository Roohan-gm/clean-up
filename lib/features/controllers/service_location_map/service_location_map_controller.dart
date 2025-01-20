import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreenController extends GetxController {
  final MapController mapController = MapController();
  final RxList<Marker> markers = <Marker>[].obs;
  Rx<LatLng?> selectedPosition = Rx<LatLng?>(null);
  Rx<LatLng?> myLocation = Rx<LatLng?>(null);
  Rx<LatLng?> draggedPosition = Rx<LatLng?>(null);
  RxBool isDragging = false.obs;
  final TextEditingController searchController = TextEditingController();
  RxList<dynamic> searchResults = <dynamic>[].obs;
  RxBool isSearching = false.obs;

  // Add marker for the selected location
  void addSelectedMarker(LatLng position) {
    selectedPosition.value = position;
    markers.clear();
    markers.add(
      Marker(
        point: position,
        width: 40,
        height: 40,
        child:  const Icon(Icons.location_pin, color: Colors.red, size: 40),
      ),
    );
  }

  // Get current location
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition();
  }

  // Show current location
  void showCurrentLocation() async {
    try {
      Position position = await determinePosition();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      mapController.move(currentLatLng, 15.0);
      myLocation.value = currentLatLng;

      Get.snackbar("Current Location", "Moved to your current location.");
    } catch (e) {
      Get.snackbar("Location Error", e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }


  // Search places
  Future<void> searchPlaces(String query) async {
    try {
      if (query.isEmpty) {
        searchResults.clear();
        return;
      }
      final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          searchResults.value = data;
        } else {
          searchResults.clear();
          Get.snackbar("No Results", "No locations found for your search.");
        }
      } else {
        throw Exception("Failed to load search results: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Search Error", e.toString());
      searchResults.clear();
    }
  }


  // Move to specific location
  void moveToLocation(double lat, double lon) {
    LatLng location = LatLng(lat, lon);
    mapController.move(location, 15.0);
    selectedPosition.value = location;

    searchResults.clear();
    isSearching.value = false;
    searchController.clear();
  }


  // Reverse geocode to get the address
  Future<String> getAddressFromLatLng(double lat, double lon) async {
    try {
      final url = 'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? "Address not available";
      } else {
        throw Exception("Failed to fetch address: ${response.statusCode}");
      }
    } catch (e) {
      return "Error fetching address: $e";
    }
  }

}
