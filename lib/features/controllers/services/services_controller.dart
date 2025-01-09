import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/repositories/services/services_repository.dart';
import '../../models/service_model.dart';

class ServicesController extends GetxController {
  final ServicesRepository repository;
  var services = <ServicesModel>[].obs;

  ServicesController(this.repository);

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  void fetchServices() async {
    try {
      final serviceList = await repository.getServices();
      if (kDebugMode) {
        print('Services fetched successfully: $serviceList');
      } // Debug fetched services
      services.assignAll(serviceList); // Assign services to the observable list
    } catch (e) {
      throw Exception('Error fetching Services: ${e.toString()}'); // Invoke .toString()
    }
  }
}
