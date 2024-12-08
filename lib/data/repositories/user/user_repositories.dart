import 'package:clean_up/features/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final SupabaseClient _db = Supabase.instance.client;

  /// Function to save user data to Supabase
  Future<void> saveUserRecord(UserModel user) async {
    try {
      final response = await _db.from('Users').insert(user.toJson()).select();
      // Check if there was an error in the response
      if (response.isEmpty) {
        throw Exception(
            'Failed to save user record.');
      }

      if (kDebugMode) {
        print('User record saved successfully: ${response.first}');
      }
    } on PlatformException catch (e) {
      throw Exception('Platform Error: ${e.message}');
    } catch (e) {
      debugPrint('Error saving user record: $e');
      throw Exception('Something went wrong. Please try again.');
    }
  }
}
