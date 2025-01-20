import 'package:clean_up/features/models/location_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/models/service_cart_model.dart';

class ServicesCartRepository {
  final SupabaseClient _client;

  ServicesCartRepository(this._client);

  /// Add a service to the cart
  Future<void> addServiceToCart(ServicesCartModel cartItem) async {
    try {
      // Insert the cart item into the `services_cart` table
      await _client.from('services_cart').insert(cartItem.toJson());
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while adding service to cart: $e');
    }
  }

  /// Get all cart items
  Future<List<ServicesCartModel>> getCartItems() async {
    try {
      final response = await _client
          .from('services_cart')
          .select('*');
      if (response.isEmpty) {
        return [];
      }
      return (response as List<dynamic>)
          .map((json) => ServicesCartModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching cart items: $e');
    }
  }

  /// Update the entire cart item
  Future<void> updateCartItem(ServicesCartModel cartItem) async {
    try {
      await _client
          .from('services_cart')
          .update(cartItem.toJson())
          .eq('id', cartItem.id);
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while updating cart item: $e');
    }
  }

  /// Update the location of a cart item
  Future<void> updateCartItemLocation(
      String cartItemId, LocationModel location) async {
    try {
      await _client
          .from('services_cart')
          .update({'location': location.toJson()}).eq('id', cartItemId);
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while updating location: $e');
    }
  }

  /// Update the special note of a cart item
  Future<void> updateCartItemSpecialNote(
      String cartItemId, String specialNote) async {
    try {
      await _client
          .from('services_cart')
          .update({'special_note': specialNote}).eq('id', cartItemId);
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while updating special note: $e');
    }
  }

  /// Change the quantity of a cart item
  Future<void> changeCartItemQuantity(String cartItemId, String serviceId, {required bool increase}) async {
    try {
      final response = await _client
          .from('services_cart')
          .select('*')
          .eq('id', cartItemId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Cart item with ID $cartItemId not found.');
      }

      final cartItem = ServicesCartModel.fromJson(response);

      // Create a copy of the services list to avoid concurrent modification
      final servicesListCopy = List.from(cartItem.servicesModel);

      // Update the quantity for the specific service
      for (var service in servicesListCopy) {
        if (service.id == serviceId) {
          service.quantity += increase ? 1 : -1;

          // If the quantity reaches zero, remove the service
          if (service.quantity <= 0) {
            cartItem.servicesModel.remove(service);
          }

          break; // Exit the loop after updating the specific service
        }
      }

      // If all services are removed, delete the cart item
      if (cartItem.servicesModel.isEmpty) {
        await _client.from('services_cart').delete().eq('id', cartItemId);
      } else {
        await _client.from('services_cart').update({
          'services_model': cartItem.servicesModel.map((service) => service.toJson()).toList(),
        }).eq('id', cartItemId);
      }

      debugPrint('Cart item with ID $cartItemId updated successfully.');
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error while updating cart item $cartItemId: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while changing quantity for cart item $cartItemId: $e');
    }
  }



  /// Remove a specific service from the cart
  Future<void> removeServiceFromCart(String cartItemId, String serviceId) async {
    try {
      final response = await _client
          .from('services_cart')
          .select('*')
          .eq('id', cartItemId)
          .maybeSingle();

      if (response == null) throw Exception('Cart item not found.');

      final cartItem = ServicesCartModel.fromJson(response);

      final initialLength = cartItem.servicesModel.length;
      cartItem.servicesModel.removeWhere((service) => service.id == serviceId);

      if (cartItem.servicesModel.isEmpty) {
        await _client.from('services_cart').delete().eq('id', cartItemId);
      } else if (cartItem.servicesModel.length != initialLength) {
        await _client.from('services_cart').update({
          'services_model': cartItem.servicesModel.map((service) => service.toJson()).toList(),
        }).eq('id', cartItemId);
      }
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while removing service: $e');
    }
  }


  /// Clear all items from the cart
  Future<void> clearCart() async {
    try {
      await _client.from('services_cart').delete();
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while clearing cart: $e');
    }
  }

  // Update the total amount of a cart item
  Future<void> updateCartItemTotalAmount(String cartItemId, double totalAmount) async {
    try {
      await _client
          .from('services_cart')
          .update({'total_price': totalAmount}).eq('id', cartItemId);
    } on PostgrestException catch (e) {
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while updating total amount: $e');
    }
  }

  // /// Calculate the total amount of the cart
  // Future<double> calculateTotalAmount() async {
  //   try {
  //     final response = await getCartItems();
  //     double totalAmount = 0;
  //     for (var cartItem in response) {
  //       for (var service in cartItem.servicesModel) {
  //         totalAmount +=
  //             service.price * service.quantity; // Calculate total price
  //       }
  //     }
  //     return totalAmount;
  //   } on PostgrestException catch (e) {
  //     throw Exception('Supabase Error: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Failed to calculate total amount: ${e.toString()}');
  //   }
  // }
}
