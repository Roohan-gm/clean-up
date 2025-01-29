import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderHistoryController extends GetxController {
  final SupabaseClient _db = Supabase.instance.client;

  var offers = <Map<String, dynamic>>[].obs; // Reactive list to store offers
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;

      // Get the logged-in user's ID
      final userId = _db.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not logged in.");
      }

      // Fetch offers from the `offer` table assigned to this user with the related user data
      final response = await _db
          .from('offer')
          .select('*')
          .eq('cleaner_id', userId);

      if (response.isEmpty) {
        offers.clear();
      } else {
        // Include the customer username in the offers list
        offers.value = List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch offers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
