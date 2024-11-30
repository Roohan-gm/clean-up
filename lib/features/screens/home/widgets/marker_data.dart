import 'package:latlong2/latlong.dart';

class MarkerData{
  final LatLng position;
  final String title;
  final String description;

  MarkerData({required this.position, required this.title, required this.description});
}