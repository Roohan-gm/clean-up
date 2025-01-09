import 'package:clean_up/features/models/user_model.dart';
import 'package:clean_up/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/user/user_repositories.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  final imageUploading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }


  /// Fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        final imageUrl = await userRepository.uploadImage(
            'User file', 'Images/profile pic', image);

        // Update User Image Record
        Map<String, dynamic> json = {'profile_picture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();
        RLoadersSnackBar.successSnackBar(
            title: 'Congratulations!',
            message: 'Your Profile picture has been updated!');
      }
    } catch (e) {
      RLoadersSnackBar.errorSnackBar(
          title: 'Oh Snap!', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }

  /// Save user Record from any Registration provider
// Future<void> saveUserRecord(SupabaseUserCredential? userCredentials) async {
//   try {
//     if (userCredentials != null) {
//       // Convert Name to First and last Name
//       final nameParts =
//           UserModel.nameParts(userCredentials.user!.displayName ?? '');
//       final username =
//           UserModel.generateUsername(userCredentials.user!.displayName ?? '');
//
//       // Map Data
//       final user = UserModel(
//         id: userCredentials.user!.id,
//         firstName: nameParts[0],
//         lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
//         username: username,
//         email: userCredentials.user!.email ?? '',
//         phoneNumber: userCredentials.user!.phone ?? '',
//         profilePicture: userCredentials.user!.photoURL ?? '',
//       );
//
//       // Save user data
//       await userRepository.saveUserRecord(user);
//     }
//   } catch (e) {
//     RLoadersSnackBar.warningSnackBar(
//         title: 'Data not saved',
//         message: 'Something went wrong while saving your information.');
//   }
// }
}
