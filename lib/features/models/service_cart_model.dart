import 'package:clean_up/features/models/service_model.dart';
import 'location_model.dart';

class ServicesCartModel {
  final String id;
  LocationModel? servicesLocation; // Nullable location model
  final List<ServicesModel> servicesModel;
  String? specialNote;
  double totalPrice;

  ServicesCartModel({
    this.servicesLocation,
    this.totalPrice = 0.0,
    required this.servicesModel,
    required this.id,
    this.specialNote,
  });

  // Factory constructor to create a ServicesCartModel object from JSON
  factory ServicesCartModel.fromJson(Map<String, dynamic> json) {
    return ServicesCartModel(
        id: json['id'],
        servicesLocation: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
        servicesModel: (json['services_model'] as List<dynamic>)
            .map((item) => ServicesModel.fromJson(item))
            .toList(),
        specialNote: json['special_note'],
        totalPrice: json['total_price']);
  }

  // Method to convert a ServicesCartModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': servicesLocation?.toJson(),
      'special_note': specialNote,
      'services_model': servicesModel.map((item) => item.toJson()).toList(),
      'total_price': totalPrice
    };
  }
}
