import 'dart:convert';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  LatLng? _selectedPosition;
  LatLng? _myLocation;
  LatLng? _draggedPosition;
  bool _isDragging = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  // get current Location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if Location services are enabled
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

  // show current location
  void _showCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentLating = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLating, 15.0);
      setState(() {
        _myLocation = currentLating;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // show marker info when tapped

  // Search Function
  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data.isNotEmpty) {
      setState(() {
        _searchResults = data;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  // move to specific location
  void _moveToLocation(double lat, double lon) {
    LatLng location = LatLng(lat, lon);
    _mapController.move(location, 15.0);
    setState(() {
      _selectedPosition = location;
      _searchResults = [];
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchPlaces(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                // initialCenter: LatLng(30.00, 70.00),
                initialZoom: 13.0,
                onTap: (tapPosition, latlng) {
                  _selectedPosition = latlng;
                  _draggedPosition = _selectedPosition;
                }),
            children: [
              TileLayer(
                urlTemplate:
                    "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(markers: _markers),
              if (_isDragging && _draggedPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _draggedPosition!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        CupertinoIcons.largecircle_fill_circle,
                        color: RColors.primary,
                        size: 35,
                      ),
                    )
                  ],
                ),
              if (_myLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: RColors.darkGrey,
                        size: 40,
                      ),
                    )
                  ],
                ),
            ],
          ),
          // search widget
          Positioned(
              top: 40,
              left: 15,
              child: Container(
                height: 55,
                decoration: const BoxDecoration(
                    color: RColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      size: 30,
                      color: RColors.darkGrey,
                    )),
              )),
          Positioned(
              top: 40,
              left: 80,
              right: 15,
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: "Search..",
                          filled: true,
                          fillColor: RColors.white,
                          hintStyle:
                              const TextStyle(fontSize: 18, color: RColors.darkGrey),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: RColors.white)),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: RColors.white, // Color when not focused
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: RColors.white, // Color when focused
                            ),
                          ),
                          prefixIcon: const Icon(CupertinoIcons.search),
                          suffixIcon: _isSearching
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _isSearching = false;
                                      _searchResults = [];
                                    });
                                  },
                                  icon: const Icon(Icons.clear))
                              : null),
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
                  ),
                  if (_isSearching && _searchResults.isNotEmpty)
                    Container(
                      color: RColors.white,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (ctx, index) {
                            final place = _searchResults[index];
                            return ListTile(
                              title: Text(place['display_name']),
                              onTap: () {
                                final lat = double.parse(place['lat']);
                                final lon = double.parse(place['lon']);
                                _moveToLocation(lat, lon);
                              },
                            );
                          }),
                    )
                ],
              )),
          // add location button
          _isDragging == false
              ? Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: RColors.primary,
                    foregroundColor: RColors.white,
                    onPressed: () {
                      setState(
                        () {
                          _isDragging = true;
                        },
                      );
                    },
                    child: const Icon(Icons.add_location),
                  ))
              : Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: RColors.darkGrey,
                    foregroundColor: RColors.white,
                    onPressed: () {
                      setState(
                        () {
                          _isDragging = false;
                        },
                      );
                    },
                    child: const Icon(Icons.wrong_location),
                  )),
          Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    backgroundColor: RColors.white,
                    foregroundColor: RColors.primary,
                    onPressed: _showCurrentLocation,
                    child: const Icon(Icons.location_searching_rounded),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
