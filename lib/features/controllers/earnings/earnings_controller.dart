import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class EarningsController extends GetxController {
  final SupabaseClient _db = Supabase.instance.client;

  var totalEarnings = 0.0.obs;
  var monthlyEarnings = 0.0.obs;
  var yearlyEarnings = 0.0.obs;
  var completedJobs = 0.obs;
  var deductions = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEarnings();
  }

  Future<void> fetchEarnings() async {
    try {
      isLoading.value = true;

      // Get the logged-in user's ID
      final userId = _db.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not logged in.");
      }

      // Fetch accepted offers for the logged-in user
      final response = await _db
          .from('offer')
          .select('*')
          .eq('cleaner_id', userId)
          .eq('status', 'accepted');

      if (response.isNotEmpty) {
        double total = 0.0;
        double monthly = 0.0;
        double yearly = 0.0;
        int jobs = 0;

        final DateTime now = DateTime.now();
        final DateFormat monthFormat = DateFormat('yyyy-MM');
        final DateFormat yearFormat = DateFormat('yyyy');

        for (var offer in response) {
          double amount = offer['offer_amount'] ?? 0.0;
          DateTime createdAt = DateTime.parse(offer['created_at']);

          total += amount;
          jobs += 1;

          if (monthFormat.format(createdAt) == monthFormat.format(now)) {
            monthly += amount;
          }

          if (yearFormat.format(createdAt) == yearFormat.format(now)) {
            yearly += amount;
          }
        }

        double deduction = total * 0.10; // Calculate deduction as 10% of total earnings

        totalEarnings.value = total;
        monthlyEarnings.value = monthly;
        yearlyEarnings.value = yearly;
        completedJobs.value = jobs;
        deductions.value = deduction;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch earnings: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
