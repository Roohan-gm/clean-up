import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../navigation_menu.dart';
import '../../../screens/offer_accepted/offer_accepted.dart';
import '../../../screens/offer_screen/offer_screen.dart';
import '../../../screens/waiting_for_response_screen/waiting_for_response_screen.dart';
import '../offer_controller.dart';

class OfferAcceptedController extends GetxController {
  // Reactive variables
  RxBool isSubmitting = false.obs;
  RxString offerStatus = ''.obs;
  RxString buttonState = "On My Way".obs;
  RxBool showTimer = false.obs;
  RxBool showConfirmationButtons = false.obs;
  Rx<Duration> cleaningDuration = Duration.zero.obs;
  RxString tempMessage = ''.obs;

  final box = GetStorage();

  // Supabase channel
  RealtimeChannel? channel;
  Timer? _timer;

  late String offerId;

  Future<void> submitOffer({
    required String orderId,
    required String customerName,
    required double offerAmount,
    required int arrivalTime,
  }) async {
    try {
      isSubmitting.value = true;

      // Submit the offer to the database
      final response = await supabaseClient
          .from('offer')
          .insert({
            'order_id': orderId,
            'offer_amount': offerAmount,
            'arrival_time': arrivalTime,
            'status': 'pending',
          })
          .select()
          .single();

      final newOfferId = response['id'];
      offerId = newOfferId; // Save the newly created offer ID
      // Redirect to WaitingForResponseScreen with offer ID
      Get.to(() => WaitingForResponseScreen(
            customerName: customerName,
            offerId: newOfferId,
          ));
    } catch (e) {
      Get.snackbar("Error", "Failed to submit offer: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> toggleButton(String orderId) async {
    try {
      String newStatus;

      if (buttonState.value == "On My Way") {
        newStatus = "on_my_way";
        buttonState.value = "I Am Here";
        showTempMessage("You are on your way. Customer has been notified.");
      } else if (buttonState.value == "I Am Here") {
        newStatus = "arrived";
        buttonState.value = "Start Cleaning";
        showTempMessage("You have arrived. Customer has been notified.");
      } else if (buttonState.value == "Start Cleaning") {
        newStatus = "cleaning_started";
        buttonState.value = "Done Cleaning";
        showTimer.value = true;
        showTempMessage("Cleaning started!");
        startTimer();
      } else if (buttonState.value == "Done Cleaning") {
        // Show confirmation buttons instead of proceeding directly
        showConfirmationButtons.value = true;
        stopTimer();
        showTimer.value = false;
        return;
      } else {
        return;
      }

      // Update the button_status column in the order table
      await supabaseClient
          .from('order')
          .update({'button_status': newStatus}).eq('id', orderId);
    } catch (e) {
      Get.snackbar("Error", "Failed to update button status: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error);
    }
  }

  void confirmCleaning(bool isDone) {
    if (isDone) {
      buttonState.value = "On My Way";
      showConfirmationButtons.value = false;
      box.remove('orderDetails');

      resetTimer();
      // Update offer status to 'completed' in the database
      updateOfferStatus('completed');
      Get.off(() => const NavigationMenu());
    } else {
      buttonState.value = "Done Cleaning";
      showConfirmationButtons.value = false;
      showTimer.value = true;
    }
  }

  void listenForOfferUpdates(String id) {
    if (channel != null) {
      Supabase.instance.client.removeChannel(channel!);
    }

    channel = supabaseClient.channel('public:offer');
    channel?.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'offer',
      filter: PostgresChangeFilter(
        column: 'id',
        type: PostgresChangeFilterType.eq,
        value: id,
      ),
      callback: (PostgresChangePayload payload) {
        final updatedStatus = payload.newRecord['status'];

        if (updatedStatus == 'accepted') {
          Get.off(() => const OfferAccepted());
          Get.snackbar(
            "Offer Accepted",
            "The customer accepted your offer.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.secondary,
          );
        } else if (updatedStatus == 'rejected') {
          Get.snackbar(
            "Offer Rejected",
            "The customer rejected your offer.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
          );
          Get.offAll(() => OfferScreen());
        }
      },
    );
    channel?.subscribe();
  }

  void showTempMessage(String message, {int duration = 3}) {
    tempMessage.value = message;
    Future.delayed(Duration(seconds: duration), () {
      tempMessage.value = '';
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      cleaningDuration.value =
          Duration(seconds: cleaningDuration.value.inSeconds + 1);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    cleaningDuration.value = Duration.zero;
  }

  Future<void> updateOfferStatus(String status) async {
    try {
      await supabaseClient
          .from('offer')
          .update({'status': status}).eq('id', offerId);
    } catch (e) {
      Get.snackbar("Error", "Failed to update offer status: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error);
    }
  }

  @override
  void onClose() {
    // Dispose of the timer if it exists
    stopTimer();

    // Unsubscribe and remove the Supabase channel if it exists
    if (channel != null) {
      Supabase.instance.client.removeChannel(channel!);
      channel = null; // Set to null for clarity
    }

    // Clear reactive variables
    isSubmitting.close();
    offerStatus.close();
    buttonState.close();
    showTimer.close();
    showConfirmationButtons.close();
    cleaningDuration.close();
    tempMessage.close();

    // Clear any related local storage
    box.remove('orderDetails');

    super.onClose();
  }
}
