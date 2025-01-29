import 'package:clean_up/features/controllers/chat_bot/widgets/dialogflow_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ChatBotController extends GetxController {
  var messages = <Map<String, String>>[].obs; // Reactive list of messages
  final TextEditingController textController = TextEditingController();
  late DialogflowService _dialogflowService;

  @override
  void onInit() {
    super.onInit();
    _dialogflowService = DialogflowService();
    _dialogflowService.initialize(); // Initialize Dialogflow service
  }

  Future<void> sendMessage(String userMessage) async {
    // Add user's message to the chat
    messages.add({'role': 'user', 'content': userMessage});

    try {
      // Get bot's reply from Dialogflow
      String botReply = await _dialogflowService.sendMessage(userMessage);

      // Add bot's reply to the chat
      messages.add({'role': 'bot', 'content': botReply});
    } catch (e) {
      // Handle errors gracefully
      messages.add({'role': 'bot', 'content': 'An error occurred. Please try again.'});
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    _dialogflowService.dispose(); // Dispose Dialogflow service
  }
}
