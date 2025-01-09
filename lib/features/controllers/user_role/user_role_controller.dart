import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRoleController extends GetxController {
  var role = 'customer'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRole(); // Load the role when the controller is initialized
  }

  // Load the role from GetStorage
  void _loadRole() {
    final box = GetStorage();
    String? savedRole = box.read('userRole');
    if (savedRole != null) {
      role.value = savedRole;
    }
  }

  // Switch roles and save to GetStorage and Supabase
  Future<void> switchRole(String newRole) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('Users')
          .update({'role': newRole})
          .eq('id', user.id)
          .select();
      if (response.isNotEmpty) {
        role.value = newRole;
        final box = GetStorage();
        box.write('userRole', newRole);
      }
    }
  }
}
