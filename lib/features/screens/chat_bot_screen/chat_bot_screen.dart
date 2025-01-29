import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../controllers/chat_bot/widgets/dialogflow_services.dart';

class ChatBotController extends GetxController {
  final DialogflowService dialogflowService = DialogflowService();
  final RxList<Map<String, String>> messages = <Map<String, String>>[].obs; // Reactive messages list
  final TextEditingController textController = TextEditingController(); // For user input
  var isInitialized = false.obs; // Track initialization state

  @override
  void onInit() {
    super.onInit();
    initializeDialogflow();
  }

  Future<void> initializeDialogflow() async {
    try {
      await dialogflowService.initialize();
      isInitialized.value = true; // Enable the UI after initialization
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing DialogflowService: $e");
      }
    }
  }

  void sendMessage() async {
    final userMessage = textController.text.trim();
    if (userMessage.isEmpty) return;

    messages.add({'role': 'user', 'content': userMessage});
    textController.clear();

    try {
      final botReply = await dialogflowService.sendMessage(userMessage);
      messages.add({'role': 'bot', 'content': botReply});
    } catch (e) {
      messages.add({'role': 'bot', 'content': 'An error occurred. Please try again.'});
      if (kDebugMode) {
        print("Error sending message: $e");
      }
    }
  }
}

class ChatBotPage extends StatelessWidget {
  ChatBotPage({super.key});

  final ChatBotController controller = Get.put(ChatBotController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.08, color: RColors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'ChatBot',
          style: TextStyle(color: RColors.white, fontSize: 24, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isUser = message['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.005, horizontal: screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: isUser ? RColors.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['content']!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Input Field and Send Button
          Obx(() {
            if (controller.isInitialized.value) {
              return Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.textController,
                        decoration: InputDecoration(
                          hintText: 'Type your question...',
                          hintStyle: TextStyle(color: RColors.white, fontSize: screenWidth * 0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    IconButton(
                      icon: Icon(Icons.send, color: RColors.white, size: screenWidth * 0.08),
                      onPressed: controller.sendMessage,
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: const CircularProgressIndicator(), // Show a loader during initialization
              );
            }
          }),
        ],
      ),
    );
  }
}
