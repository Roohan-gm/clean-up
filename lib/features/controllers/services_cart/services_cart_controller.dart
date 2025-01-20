import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:uuid/uuid.dart';

import '../../../data/repositories/services_cart/services_cart_repositories.dart';
import '../../models/location_model.dart';
import '../../models/service_cart_model.dart';
import '../../models/service_model.dart';

class ServicesCartController extends GetxController {
  // Get.put(ServicesCartRepository(supabaseClient));
  Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  RxString selectedAddress = ''.obs;
  final ServicesCartRepository _repository;
  var cartItems = <ServicesCartModel>[].obs;
  var services =
      <ServicesModel>[].obs; // Assuming services are populated elsewhere
  var totalAmount = 0.0.obs;
  final Uuid uuid = const Uuid(); // Unique ID generator
  final cartId = ''.obs;
  var specialNote = ''.obs;

  ServicesCartController(this._repository);

  @override
  void onInit() {
    super.onInit();
    if (cartId.value.isEmpty) {
      cartId.value = uuid.v4(); // Generate a unique ID for the cart
    }
    fetchCartItems();
  }

  void fetchCartItems() async {
    try {
      final items = await _repository.getCartItems();
      cartItems.assignAll(items);
      // Recalculate total amount whenever cart items are fetched
      calculateTotalAmount();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch cart items: $e');
      }
    }
  }

  // Add a service to the cart
  void addItemToCart(ServicesModel service) async {
    try {
      if (cartItems.isEmpty) {
        final cartItem = ServicesCartModel(
          id: cartId.value,
          servicesModel: [service],
          specialNote: '',
        );
        await _repository.addServiceToCart(cartItem);
        cartItems.add(cartItem);
      } else {
        final existingCartItem = cartItems.first;
        existingCartItem.servicesModel.add(service);
        await _repository.updateCartItem(existingCartItem);
        cartItems.refresh(); // Notify listeners to update the UI
      }
      // Recalculate total amount after adding item
      await calculateTotalAmount();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add item to cart: $e');
      }
    }
  }

  // Update the location of a cart item
  void updateCartItemLocation(String cartItemId, LocationModel location) async {
    try {
      await _repository.updateCartItemLocation(cartItemId, location);
      fetchCartItems(); // Refresh cart items to reflect changes
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update cart item location: $e');
      }
    }
  }

  // Update the special note of a cart item
  void updateCartItemSpecialNote(String specialNote) async {
    try {
      // Directly update the special note in the cart
      final cartItem = cartItems.isNotEmpty ? cartItems.first : null;

      if (cartItem != null) {
        cartItem.specialNote = specialNote;

        // Call the repository to update the special note in the database
        await _repository.updateCartItemSpecialNote(cartItem.id, specialNote);

        // Refresh cart items to reflect changes
        fetchCartItems();
      } else {
        if (kDebugMode) {
          print('No cart found.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update special note: $e');
      }
    }
  }

  // Increase the quantity of a cart item
  void increaseCartItemQuantity(String cartItemId, String serviceId) async {
    try {
      await _repository.changeCartItemQuantity(cartItemId, serviceId,
          increase: true);
      fetchCartItems(); // Refresh cart items to reflect changes
    } catch (e) {
      if (kDebugMode) {
        print('Failed to increase cart item quantity: $e');
      }
    }
  }

  // Decrease the quantity of a cart item
  void decreaseCartItemQuantity(String cartItemId, String serviceId) async {
    try {
      await _repository.changeCartItemQuantity(cartItemId, serviceId,
          increase: false);
      fetchCartItems(); // Refresh cart items to reflect changes
    } catch (e) {
      if (kDebugMode) {
        print('Failed to decrease cart item quantity: $e');
      }
    }
  }

  // Remove a specific service from the cart
  void removeServiceFromCart(String cartItemId, String serviceId) async {
    try {
      await _repository.removeServiceFromCart(cartItemId, serviceId);
      fetchCartItems(); // Refresh cart items to reflect changes
    } catch (e) {
      if (kDebugMode) {
        print('Failed to remove service from cart: $e');
      }
    }
  }

  // Clear all items from the cart
  void clearCart() async {
    try {
      await _repository.clearCart();
      cartItems.clear(); // Clear local cart items
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear cart: $e');
      }
    }
  }

  // Calculate the total amount of the cart
  Future<void> calculateTotalAmount() async {
    try {
      double total = 0;
      for (var cartItem in cartItems) {
        for (var service in cartItem.servicesModel) {
          total += service.price * service.quantity;
        }
      }
      totalAmount.value = total;
      // Directly update the special note in the cart
      final cartItem = cartItems.isNotEmpty ? cartItems.first : null;

      if (cartItem != null) {
        cartItem.totalPrice = totalAmount.value;
      }
      // Update the total amount in the database
      await _repository.updateCartItemTotalAmount(cartItems.first.id, totalAmount.value);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to calculate total amount: $e');
      }
    }
  }
}
