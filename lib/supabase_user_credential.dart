import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUserCredential{
  final User? user;
  final Session? session;

  SupabaseUserCredential({required this.user,required this.session});
}