import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RatingController extends GetxController {
  final SupabaseClient _db = Supabase.instance.client;

  var averageRating = 0.0.obs; // Observable for average rating as double
  var totalReviews = 0.obs;   // Observable for total reviews as integer

  Future<void> fetchRatingData() async {
    try {
      // Get the logged-in user's ID
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not logged in.");
      }

      // Query the Supabase `rating` table for the rating data
      final response = await _db
          .from('rating')
          .select('rating')
          .eq('cleaner_id', userId);

      if (response.isEmpty) {
        throw Exception("No ratings found.");
      }

      // Calculate total reviews and average rating
      int total = response.length;
      double sum = 0.0;
      for (var rating in response) {
        sum += rating['rating'] ?? 0.0;
      }
      double average = sum / total;

      // Update the observable values
      averageRating.value = average;
      totalReviews.value = total;

      // Update the `Users` table
      await _db
          .from('Users')
          .update({
        'avg_rating': average,
        'total_rating': total,
      })
          .eq('id', userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch rating data: $e");
    }
  }
}
