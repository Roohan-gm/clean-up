import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class DialogflowService {
  static const _dialogflowUrl =
      "https://dialogflow.googleapis.com/v2/projects/{PROJECT_ID}/agent/sessions/{SESSION_ID}:detectIntent";

  late String _projectId;
  AuthClient? _authClient; // Use nullable AuthClient to handle uninitialized state
  final String knowledgeBaseId = 'MTQ5OTM5MDAxNTUxMjY2Nzc1MDU';

  /// Initializes the service by loading credentials and setting up authentication
  Future<void> initialize() async {
    try {
      // Load the service account credentials from the assets folder
      final credentialsJson =
      await rootBundle.loadString('assets/clean-up-39d88-f075a7156ffb.json');
      final Map<String, dynamic> credentialsMap = jsonDecode(credentialsJson);
      final credentials = ServiceAccountCredentials.fromJson(credentialsMap);

      // Extract the project ID from the service account JSON
      _projectId = credentialsMap['project_id'];

      // Define the required scopes for Dialogflow
      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

      // Authenticate using the service account credentials
      _authClient = await clientViaServiceAccount(credentials, scopes);
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing DialogflowService: $e");
      }
      rethrow;
    }
  }

  /// Sends a user message to the Dialogflow API and returns the bot's response
  Future<String> sendMessage(String message) async {
    if (_authClient == null) {
      throw Exception("DialogflowService not initialized. Call initialize() first.");
    }

    // Generate a unique session ID (could use UUID or other user-specific identifiers)
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final url = _dialogflowUrl
        .replaceAll("{PROJECT_ID}", _projectId)
        .replaceAll("{SESSION_ID}", sessionId);

    final body = {
      "queryInput": {
        "text": {
          "text": message,
          "languageCode": "en-US",
        }
      },"queryParams": {
        "knowledgeBaseNames": ["projects/$_projectId/knowledgeBases/$knowledgeBaseId"]
      }
    };

    try {
      final response = await _authClient!.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (kDebugMode) {
          print("Knowledge Results: ${data['queryResult']['knowledgeAnswers']}");
        }
        return data['queryResult']['fulfillmentText'] ??
            "Sorry, I couldn't understand that.";
      } else {
        throw Exception("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending message to Dialogflow: $e");
      }
      rethrow;
    }
  }

  /// Disposes of the authenticated client when no longer needed
  void dispose() {
    _authClient?.close();
  }
}
