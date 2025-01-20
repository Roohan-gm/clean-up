import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadServiceAccount() async {
  await dotenv.load();
  String? serviceAccountPath = dotenv.env['SERVICE_ACCOUNT_PATH'];

  if (serviceAccountPath != null) {
    try {
      String serviceAccountKey = await File(serviceAccountPath).readAsString();
      Map<String, dynamic> serviceAccount = jsonDecode(serviceAccountKey);
      if (kDebugMode) {
        print(serviceAccount['project_id']);
      } // Example usage
    } catch (e) {
      if (kDebugMode) {
        print("Error reading the service account file: $e");
      }
    }
  } else {
    if (kDebugMode) {
      print("Service account path not found in .env file!");
    }
  }
}
