import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatBotController extends GetxController {
  var messages = <Map<String, String>>[].obs; // Reactive list of messages
  final TextEditingController textController = TextEditingController();

  Future<void> sendMessage(String userMessage) async {
    // Add user's message to chat
    messages.add({'role': 'user', 'content': userMessage});

    try {
      // Call Supabase Edge Function
      final response = await http.post(
        Uri.parse('https://your-supabase-url.supabase.co/functions/v1/faq-bot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': userMessage}),
      );

      // Parse the response
      final data = jsonDecode(response.body);
      String botReply = data['answer'] ?? "Sorry, I couldn't find an answer to that.";

      // Add bot's reply to chat
      messages.add({'role': 'bot', 'content': botReply});
    } catch (e) {
      // Handle errors gracefully
      messages.add({'role': 'bot', 'content': 'An error occurred. Please try again.'});
    }
  }
}