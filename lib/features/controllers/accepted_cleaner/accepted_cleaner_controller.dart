import 'package:clean_up/features/screens/home/home.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../screens/give_rating/give_rating.dart';
import '../../screens/start_cleaning/start_cleaning.dart';
import '../offer/offer_controller.dart';

class AcceptedCleanerController extends GetxController {
  late Map<String, dynamic> cleanerDetails;
  late Map<String, dynamic> offerDetails;
  late Map<String, dynamic> orderDetails;
  late List<dynamic> servicesCart;

  var cleaningDuration = 'Loading...'.obs;
  var selectedStars = 0.obs;
  var isLoading = false.obs;
  final commentController = TextEditingController();

  // Reactive variables for cleaner and client locations
  final cleanerLocation = LatLng(0, 0).obs;
  final clientLocation = LatLng(0, 0).obs;

  var buttonState = "Coming".obs; // Initial button state
  // Supabase channel
  RealtimeChannel? channel;
  RealtimeChannel? notificationChannel;

  @override
  void onInit() {
    super.onInit();
    final storage = GetStorage();

    // Retrieve data from GetStorage
    cleanerDetails = storage.read('cleanerDetails') ?? {};
    offerDetails = storage.read('offerDetails') ?? {};
    orderDetails = storage.read('orderDetails') ?? {};

    if (kDebugMode) {
      print("Cleaner details: $cleanerDetails");
      print("Offer details: $offerDetails");
      print("Order details: $orderDetails");
    }

    // Validate data
    if (cleanerDetails.isEmpty || offerDetails.isEmpty) {
      Get.snackbar(
        'Error',
        'Required data is missing. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.onError,
        colorText: RColors.white,
      );
      return;
    }
    try {
      // Extract services_cart data
      servicesCart = offerDetails['order']['services_cart'] ?? [];

      // Initialize locations
      cleanerLocation.value = LatLng(
        cleanerDetails['current_location']['latitude'] ?? 0,
        cleanerDetails['current_location']['longitude'] ?? 0,
      );
      clientLocation.value = LatLng(
        servicesCart[0]['location']['latitude'] ?? 0,
        servicesCart[0]['location']['longitude'] ?? 0,
      );

      // Listen for cleaner updates
      final orderId = offerDetails['order_id'];
      if (orderId != null) {
        listenForCleanerUpdates(orderId);
      } else {
        Get.snackbar(
          'Error',
          'Order ID is missing.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.onError,
          colorText: RColors.white,
        );
      }
      if (kDebugMode) {
        print("Cleaner id: $cleanerDetails['id']");
      }
      // Subscribe to notifications
      subscribeToNotifications(cleanerDetails['id']);
    } catch (e) {
      if (kDebugMode) {
        print("Error in onInit: $e");
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
    notificationChannel = supabaseClient.channel('public:notification');

    if (kDebugMode) {
      print("Subscribing to notifications for user ID: $userId");
    }

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
          print("New notification received: ${payload.newRecord}");
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
    try {
      await supabaseClient
          .from('notification')
          .update({'is_read': true}).eq('id', notificationId);
      if (kDebugMode) {
        print("Notification marked as read: $notificationId");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error marking notification as read: $e");
      }
      Get.snackbar('Error', 'Failed to mark notification as read: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: RColors.white);
    }
  }

  Future<void> toggleButton(String orderId) async {
    try {
      String newStatus = '';

      if (buttonState.value == "Coming") {
        newStatus = "coming";
        buttonState.value = "Start Cleaning";
        notifyCleaner("Customer on Their Way",
            "The customer is heading to your location.", offerDetails['cleaner_id']);
        if (kDebugMode) {
          print("Toggling button: Coming -> Start Cleaning");
        }
        // Update the button_status column in the order table
        await supabaseClient
            .from('order')
            .update({'button_status': newStatus}).eq('id', orderId);
      } else if (buttonState.value == "Start Cleaning") {
        newStatus = "start_cleaning";
        buttonState.value = "Coming";
        if (kDebugMode) {
          print("Toggling button: Start Cleaning -> Coming");
        }
        // Update the button_status column in the order table
        await supabaseClient
            .from('order')
            .update({'button_status': newStatus}).eq('id', orderId);
        notifyCleaner(
            "Start cleaning",
            "cleaning has started and it is being timed.",
            offerDetails['cleaner_id']);

        Get.to(() => const StartCleaning());
      } else {
        if (kDebugMode) {
          print("Unknown button state: ${buttonState.value}");
        }
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in toggleButton: $e");
      }
      Get.snackbar("Error", "Failed to update button status: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: RColors.white);
    }
  }

  void notifyCleaner(String title, String message, String id) {
    try {
      supabaseClient.from('notification').insert({
        'title': title,
        // Title of the notification
        'message': message,
        'user_id': id,
        // Cleaner user ID for targeting
        'order_id': offerDetails['order_id'],
        // Use the order ID from offer details
      });
      if (kDebugMode) {
        print("Notification sent to cleaner: title: $title - message: $message - order_id: ${offerDetails['order_id']} - cleaner_id###: $id");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending notification: $e");
      }
      Get.snackbar("Error", "Failed to notify cleaner: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: RColors .white);
    }
  }

  void listenForCleanerUpdates(String orderId) {
    if (channel != null) {
      Supabase.instance.client.removeChannel(channel!);
    }
    if (kDebugMode) {
      print("Listening for updates on order ID: $orderId");
    }

    channel = supabaseClient.channel('public:order');
    channel?.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'order',
      filter: PostgresChangeFilter(
        column: 'id',
        type: PostgresChangeFilterType.eq,
        value: orderId,
      ),
      callback: (PostgresChangePayload payload) {
        final updatedStatus = payload.newRecord['button_status'];

        if (kDebugMode) {
          print("Order update received: $updatedStatus");
        }
        if (updatedStatus == 'on_my_way') {
          Get.snackbar("Get ready!", "The cleaner is on their way..",
              snackPosition: SnackPosition.TOP,
              backgroundColor: RColors.primary,
              colorText: RColors.white);
        } else if (updatedStatus == 'arrived') {
          // Notify customer that the cleaner has arrived
          Get.snackbar("Cleaner arrived!",
              "The cleaner has arrived. go and receive you cleaner.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: RColors.primary,
              colorText: RColors.white);
        } else if (updatedStatus == 'cleaning_completed') {
          Get.snackbar("Cleaning Completed",
              "The cleaner has completed his work please give rating.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: RColors.primary,
              colorText: RColors.white);
          Get.to(() => const GiveRating());
        }
      },
    );
    channel?.subscribe();
  }

  Future<void> fetchCleaningDuration() async {
    try {
      final orderId = offerDetails['order_id'];
      final response = await Supabase.instance.client
          .from('order')
          .select('cleaning_duration')
          .eq('id', orderId)
          .single();

      if (response.isNotEmpty) {
        cleaningDuration.value =
            response['cleaning_duration']?.toString() ?? 'N/A';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch cleaning duration: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> submitRating() async {
    if (selectedStars.value == 0) {
      Get.snackbar(
        'Error',
        'Please select a rating.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: RColors.white
      );
      return;
    }

    try {
      isLoading.value = true;

      // Prepare data for the rating table
      final ratingData = {
        'cleaner_id': cleanerDetails['id'],
        'customer_id': orderDetails['customer_id'],
        'rating': selectedStars.value,
        'comment': commentController.text.trim(),
        'order_id': offerDetails['order_id'],
      };

      // Insert rating into the database
      await Supabase.instance.client.from('rating').insert(ratingData);

      Get.snackbar('Success', 'Thank you for your feedback!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: RColors.primary,
          colorText: RColors.white);

      // Navigate to the home screen
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit rating: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: RColors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();

    // Reset reactive variables
    cleanerLocation.value = LatLng(0, 0);
    clientLocation.value = LatLng(0, 0);
 
    // Remove channels
    if (notificationChannel != null) {
      Supabase.instance.client.removeChannel(notificationChannel!);
    }
    if (channel != null) {
      Supabase.instance.client.removeChannel(channel!);
    }

    // Dispose of text controllers
    commentController.dispose();
  }
}
