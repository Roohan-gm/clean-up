class LocationModel {
  final String address;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] ?? 'Unknown Address',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }
}