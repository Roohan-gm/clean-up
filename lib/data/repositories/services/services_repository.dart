import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/models/service_model.dart';

class ServicesRepository {
  final SupabaseClient _client;

  ServicesRepository(this._client);

  /// Fetch all services from the 'services' table
  Future<List<ServicesModel>> getServices() async {
    try {
      // Fetch services from the 'services' table
      final response = await _client.from('services').select();

      if (kDebugMode) {
        print('Supabase response: $response');
      } // Debug the response

      // Ensure the response is a List of dynamic data
      if (response.isEmpty) {
        return []; // Return an empty list if no services are found
      }

      // Map the response to a list of ServicesModel
      final List<dynamic> data = response;
      return data.map((json) => ServicesModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      throw Exception('Supabase Error: ${e.message}');
    } catch (e) {
      // Handle other unexpected errors
      throw Exception('Unexpected error: $e');
    }
  }
}
