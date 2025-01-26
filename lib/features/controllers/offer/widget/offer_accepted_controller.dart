import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../screens/offer_accepted/offer_accepted.dart';
import '../../../screens/offer_screen/offer_screen.dart';
import '../../../screens/waiting_for_response_screen/waiting_for_response_screen.dart';
import '../offer_controller.dart';

class OfferAcceptedController extends GetxController {
  // Reactive variables
  RxBool isSubmitting = false.obs;
  RxBool showButton = true.obs;

  // final RxString buttonState = "On My Way".obs;
  var buttonState = "On My Way".obs;
  RxBool showTimer = false.obs;
  Rx<Duration> cleaningDuration = Duration.zero.obs;

  RealtimeChannel? notificationChannel;
  final box = GetStorage();
  RealtimeChannel? customerChannel;
  RealtimeChannel? offerChannel;

  Timer? _timer;
  late String offerId;
  // late String order_id;

  @override
  void onInit() {
    if (kDebugMode) {
      debugPrint('onInit called');
    }

    super.onInit();

    // listenForCustomerUpdates(box.read('offerDetails')['order_id']);
    // subscribeToNotifications(box.read('orderDetails')?['customer_id']);
    try {
      // Retrieve the offer ID from local storage
      offerId = box.read('offerDetails')?['id'] ?? '';
      if (kDebugMode) {
        debugPrint('Offer ID retrieved: $offerId');
      }
      listenForOfferUpdates(offerId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error in onInit: $e");
      }
      Get.snackbar(
        'Error',
        'Invalid data format: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.onError,
        colorText: RColors.white,
      );
    }
  }

  void subscribeToNotifications(String userId) {
    if (kDebugMode) {
      print('subscribeToNotifications called with customer_id: $userId');
    }
    notificationChannel = supabaseClient.channel('public:notification');

    notificationChannel?.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'notification',
      filter: PostgresChangeFilter(
        column: 'user_id',
        type: PostgresChangeFilterType.eq,
        value: userId,
      ),
      callback: (PostgresChangePayload payload) {
        if (kDebugMode) {
          print('Notification received: ${payload.newRecord}');
        }
        final newNotification = payload.newRecord;
        Get.snackbar(newNotification['title'], newNotification['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: RColors.primary,
            colorText: RColors.white);
        isRead(newNotification['id']); // Mark notification as read
      },
    );
    notificationChannel?.subscribe();
  }

  Future<void> isRead(String notificationId) async {
    if (kDebugMode) {
      print('isRead called for notificationId: $notificationId');
    }
    try {
      await supabaseClient
          .from('notification')
          .update({'is_read': true}).eq('id', notificationId);
      if (kDebugMode) {
        print('Notification marked as read: $notificationId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
      Get.snackbar('Error', 'Failed to mark notification as read: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: RColors.white);
    }
  }

  Future<void> submitOffer({
    required String orderId,
    required String customerName,
    required double offerAmount,
    required int arrivalTime,
  }) async {
    if (kDebugMode) {
      print(
          'submitOffer called with orderId: $orderId, customerName: $customerName, offerAmount: $offerAmount, arrivalTime: $arrivalTime');
    }
    // order_id = orderId;
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
      if (kDebugMode) {
        print('Offer submitted successfully: $response');
      }
      final newOfferId = response['id'];
      offerId = newOfferId; // Save the newly created offer ID

      // Redirect to WaitingForResponseScreen with offer ID
      Get.to(() => WaitingForResponseScreen(
            customerName: customerName,
            offerId: newOfferId,
          ));
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting offer: $e');
      }
      Get.snackbar("Error", "Failed to submit offer: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: RColors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> toggleButton(String orderId) async {
    if (kDebugMode) {
      print('toggleButton called with orderId: $orderId');
    }
    try {
      String newStatus = '';

      if (buttonState.value == "On My Way") {
        newStatus = "on_my_way";
        buttonState.value = "I Am Here";
        notifyCustomer(
            "Cleaner on the way",
            "A cleaner has been assigned to your order. Please check the details.",
            box.read('orderDetails')?['customer_id']);
      } else if (buttonState.value == "I Am Here") {
        newStatus = "arrived";
        showButton.value = false;
        notifyCustomer(
            "Cleaner arrived!",
            "A cleaner has arrived at the location. Please go receive the cleaner.",
            box.read('orderDetails')?['customer_id']);
      } else if (buttonState.value == "Done Cleaning") {
        Get.defaultDialog(
          backgroundColor: RColors.white,
          title: "Cleaning Confirmation",
          titleStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: RColors.black,
          ),
          content: Column(
            children: [
              const Text(
                "Are you sure the cleaning has been completed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: RColors.darkGrey,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          confirm: ElevatedButton(
            onPressed: () {
              confirmCleaning(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              side: const BorderSide(color: RColors.grey, width: 2),
            ),
            child: const Text(
              "Yes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: RColors.white),
            ),
          ),
          cancel: ElevatedButton(
            onPressed: () {
              buttonState.value = "Done Cleaning";
              Get.back(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RColors.darkGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              side: const BorderSide(color: RColors.grey, width: 2),
            ),
            child: const Text(
              "No",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: RColors.white),
            ),
          ),
        );


      } else {
        return;
      }
      if (newStatus.isNotEmpty) {
        await supabaseClient
            .from('order')
            .update({'button_status': newStatus}).eq('id', orderId);
        if (kDebugMode) {
          print('Order updated with new status: $newStatus');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling button: $e');
      }
      Get.snackbar("Error", "Failed to update button status: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: RColors.white);
    }
  }

  Future<void> confirmCleaning(bool isDone) async {
    if (kDebugMode) {
      print('confirmCleaning called with isDone: $isDone');
    }
    stopTimer(); // Stop the timer to get the final duration

    if (isDone) {
      notifyCustomer(
          "Cleaning completed!",
          "A cleaner is done with the cleaning. Please give rating to the cleaner.",
          box.read('orderDetails')?['customer_id']);

      try {
        // Update the `button_status` column and store the total cleaning duration in the `order` table
        await supabaseClient.from('order').update({
          'button_status': 'cleaning_completed',
          'cleaning_duration': cleaningDuration.value.inMinutes,
          // Assuming `cleaning_duration` column exists
        }).eq('id', box.read('orderDetails')['orderId']);

        if (kDebugMode) {
          print(
              'Order updated with cleaning duration: $cleaningDuration.value.inMinutes');
        }
        resetTimer();

        // Update offer status to 'completed' in the database
        await updateOfferStatus('completed');
        // Clear any related local storage
        box.remove('orderDetails');
        Get.off(() => OfferScreen());
      } catch (e) {
        if (kDebugMode) {
          print('Error updating order with cleaning duration: $e');
        }
        Get.snackbar(
            "Error", "Failed to update order with cleaning duration: $e",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: RColors.white);
      }
    } else {
      buttonState.value = "Done Cleaning";
      showTimer.value = true;
      startTimer();
    }
  }

  void notifyCustomer(String title, String message, String id) {
    if (kDebugMode) {
      print(
          'notifyCustomer called with title: $title, message: $message, customerId: $id');
    }
    try {
      supabaseClient.from('notification').insert({
        'title': title,
        // Title of the notification
        'message': message,
        'user_id': id,
        // Customer user ID for targeting
        'order_id': box.read('orderDetails')['orderId'],
        // Retrieve the order ID
      });
      if (kDebugMode) {
        print('Customer notified: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error notifying customer: $e');
      }
      Get.snackbar("Error", "Failed to notify customer: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: RColors.white);
    }
  }

  void listenForCustomerUpdates(String orderId) {
    if (kDebugMode) {
      print('listenForCustomerUpdates called for orderId: $orderId');
    }
    if (customerChannel != null) {
      Supabase.instance.client.removeChannel(customerChannel!);
    }

    customerChannel = supabaseClient.channel('public:order');
    customerChannel?.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'order',
      filter: PostgresChangeFilter(
        column: 'id',
        type: PostgresChangeFilterType.eq,
        value: orderId,
      ),
      callback: (PostgresChangePayload payload) {
        if (kDebugMode) {
          print('Customer update received: ${payload.newRecord}');
        }
        final updatedStatus = payload.newRecord['button_status'];

        if (updatedStatus == 'coming') {
          Get.snackbar(
            "Coming",
            "The customer is on their way.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: RColors.primary,
            colorText: RColors.white
          );
        } else if (updatedStatus == 'start_cleaning') {
          showTimer.value = true;
          startTimer();
          buttonState.value = "Done Cleaning";
          showButton.value = true;
          Get.snackbar("Start Cleaning",
              "The customer has pressed the start cleaning button. Please do a good job.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: RColors.primary,
              colorText: RColors.white);
        }
      },
    );
    customerChannel?.subscribe();
  }

  void listenForOfferUpdates(String id) {
    if (kDebugMode) {
      print('listenForOfferUpdates called for offerId: $offerId');
    }
    if (offerChannel != null) {
      Supabase.instance.client.removeChannel(offerChannel!);
    }

    offerChannel = supabaseClient.channel('public:offer');
    offerChannel?.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'offer',
      filter: PostgresChangeFilter(
        column: 'id',
        type: PostgresChangeFilterType.eq,
        value: id,
      ),
      callback: (PostgresChangePayload payload) {
        if (kDebugMode) {
          print('Offer update received: ${payload.newRecord}');
        }
        final updatedStatus = payload.newRecord['status'];

        if (updatedStatus == 'accepted') {
          Get.off(() => const OfferAccepted());
          Get.snackbar("Offer Accepted", "The customer accepted your offer.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: RColors.primary,
              colorText: RColors.white);
        } else if (updatedStatus == 'rejected') {
          Get.snackbar("Offer Rejected", "The customer rejected your offer.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.colorScheme.error,
              colorText: RColors.white);
          Get.offAll(() => OfferScreen());
        }
      },
    );
    offerChannel?.subscribe();
  }

  void startTimer() {
    if (kDebugMode) {
      print('startTimer called');
    }
    if (_timer?.isActive ?? false) {
      return; // Timer is already running
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      cleaningDuration.value =
          Duration(seconds: cleaningDuration.value.inSeconds + 1);
    });
  }

  void stopTimer() {
    if (kDebugMode) {
      print('stopTimer called');
    }
    _timer?.cancel();
  }

  void resetTimer() {
    if (kDebugMode) {
      print('resetTimer called');
    }
    cleaningDuration.value = Duration.zero;
  }

  Future<void> updateOfferStatus(String status) async {
    if (kDebugMode) {
      print('updateOfferStatus called with status: $status');
    }
    try {
      await supabaseClient.from('order').update({'status': status}).eq(
          'id', box.read('orderDetails')['orderId']);
      if (kDebugMode) {
        print('Offer status updated to: $status');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating offer status: $e');
      }
      Get.snackbar("Error", "Failed to update offer status: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: RColors.white);
    }
  }

  @override
  void onClose() {
    if (kDebugMode) {
      print('onClose called');
    }
    stopTimer();

    // Unsubscribe and remove the Supabase channels
    if (customerChannel != null) {
      Supabase.instance.client.removeChannel(customerChannel!);
    }
    if (offerChannel != null) {
      Supabase.instance.client.removeChannel(offerChannel!);
    }
    if (notificationChannel != null) {
      Supabase.instance.client.removeChannel(notificationChannel!);
    }

    buttonState.value = "On My Way";
    // Clear reactive variables
    isSubmitting.value = false;
    showTimer.value = false;
    cleaningDuration.value = Duration.zero.obs as Duration;

    super.onClose();
  }
}
