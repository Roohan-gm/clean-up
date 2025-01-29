import 'package:clean_up/data/repositories/order/order_repositories.dart';
import 'package:clean_up/features/controllers/order/order_controller.dart';
import 'package:clean_up/utils/http/network_manager.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/services/services_repository.dart';
import '../data/repositories/services_cart/services_cart_repositories.dart';
import '../features/controllers/offer/offer_controller.dart';
import '../features/controllers/offer/widget/offer_accepted_controller.dart';
import '../features/controllers/rating/rating_controller.dart';
import '../features/controllers/service_location_map/service_location_map_controller.dart';
import '../features/controllers/services/services_controller.dart';
import '../features/controllers/services_cart/services_cart_controller.dart';
import '../features/controllers/user/user_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize NetworkManager for global access
    Get.put(NetworkManager());

    // Supabase client will be used in multiple repositories
    final supabaseClient = Supabase.instance.client;

    Get.put(ServicesCartRepository(Supabase.instance.client));

    Get.lazyPut(
          () => ServicesCartController(Get.find<ServicesCartRepository>()),
      fenix: true, // Ensures the controller is recreated when needed
    );
    // Get.lazyPut<AuthenticationRepository>(() => AuthenticationRepository());    // Directly instantiate and bind ServicesController with its repository
    // Use Get.put() since this is essential for the app's functionality
    final servicesRepository = ServicesRepository(supabaseClient);
    Get.put(ServicesController(servicesRepository));
    Get.put(UserController());
    Get.put(RatingController());
    Get.put(MapScreenController());
    Get.put(OrderRepository(Supabase.instance.client));
    Get.put(OrderController(Get.find<OrderRepository>()));
    Get.put(OfferController());
    // Get.put(AvailableCleanerController());
    Get.put(OfferAcceptedController());
  }
}
