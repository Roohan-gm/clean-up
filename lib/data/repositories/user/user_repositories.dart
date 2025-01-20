import 'dart:io';
import 'package:clean_up/data/repositories/authentication/authentication_repository.dart';
import 'package:clean_up/features/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final SupabaseClient _db = Supabase.instance.client;


  /// Save user data to Supabase
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.from('Users').insert(user.toJson());
    } on PlatformException catch (e) {
      throw Exception('Platform Error: ${e.message}');
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      debugPrint('Error saving user record: $e');
      throw Exception('Unexpected error. Please try again.');
    }
  }

  /// Fetch user details based on user ID
  Future<UserModel> fetchUserDetails() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null) {
        throw Exception('User not logged in.');
      }

      final response =
      await _db.from('Users').select().eq('id', userId).maybeSingle();
      if (response == null) {
        return UserModel.empty();
      }

      return UserModel.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      throw Exception('Unexpected error. Please try again.');
    }
  }



  /// Update user details in Supabase
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .from('Users')
          .update(updatedUser.toJson())
          .eq('id', updatedUser.id);
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      debugPrint('Error updating user details: $e');
      throw Exception('Unexpected error. Please try again.');
    }
  }

  /// Update a single field in user data
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null) {
        throw Exception('User not logged in.');
      }
      await _db.from('Users').update(json).eq('id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      debugPrint('Error updating single field: $e');
      throw Exception('Unexpected error. Please try again.');
    }
  }

  /// Remove user record from Supabase
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.from('Users').delete().eq('id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      debugPrint('Error removing user record: $e');
      throw Exception('Unexpected error. Please try again.');
    }
  }

  /// Upload an image to Supabase storage
  Future<String> uploadImage(String bucketName, String path, XFile image) async {
    try {
      final file = File(image.path);
      if (!file.existsSync()) {
        throw Exception('File does not exist.');
      }

      final destinationPath = '$path/${image.name}';

      // Upload file to Supabase storage
      await _db.storage.from(bucketName).upload(destinationPath, file);

      // Generate public URL
      final url = _db.storage.from(bucketName).getPublicUrl(destinationPath);

      return url;
    } on PostgrestException catch (e) {
      throw Exception('Storage Error: ${e.message}');
    } catch (e) {
      debugPrint('Error uploading image: $e');
      throw Exception('Unexpected error. Please try again.');
    }
  }
}
