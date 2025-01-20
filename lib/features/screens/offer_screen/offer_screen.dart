import 'package:clean_up/features/screens/home/home.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/images/circular_image.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/popups/shimmer.dart';
import '../../controllers/offer/offer_controller.dart';
import '../../controllers/offer/widget/offer_list.dart';
import '../../controllers/offer/widget/searching_offer_screen.dart';
import '../../controllers/user/user_controller.dart';
import '../../controllers/user_role/user_role_controller.dart';
import '../offline_screen/offline_screen.dart';

class OfferScreen extends GetView<OfferController> {
  OfferScreen({super.key});

  // Create a GlobalKey for the Scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomNavigationDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.element_plus, color: Theme.of(context).primaryColor),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Obx(() => Switch(
              value: controller.isOnline.value,
              onChanged: (_) => controller.toggleOnlineStatus(),
              activeColor: RColors.primary,
              trackOutlineColor: const WidgetStatePropertyAll(RColors.white),
              thumbColor: const WidgetStatePropertyAll(RColors.white),
              inactiveTrackColor: RColors.secondary,
            )),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(RImages.user),
              radius: 20,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const SearchingOfferScreen();
        }
        if (!controller.isOnline.value) {
          return const OfflineScreen();
        } else if (!controller.hasOffers.value) {
          return const SearchingOfferScreen();
        } else {
          return OfferList(
            cleanerLatitude:  controller.currentLocation.value!.latitude,
            cleanerLongitude: controller.currentLocation.value!.longitude,
          );
        }
      }),
    );
  }
}

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: RColors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[buildHeader(context), buildMenuItems(context)],
        ),
      ),
    );
  }

  buildHeader(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    return Material(
      color: RColors.primary,
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, bottom: 20),
        child: Column(
          children: [
            Obx(() {
              final networkImage = controller.user.value.profilePicture;
              final image =
                  networkImage.isNotEmpty ? networkImage : RImages.user;

              return controller.imageUploading.value
                  ? const RShimmerEffect(
                      width: 80,
                      height: 80,
                      radius: 80,
                    )
                  : RCircularImage(
                      image: image,
                      isNetworkImage: networkImage.isNotEmpty,
                      width: 80,
                      height: 80,
                    );
            }),
            const SizedBox(
              height: 6,
            ),
            TextButton(
                onPressed: () => controller.uploadUserProfilePicture(),
                child: const Text(
                  'Add Profile',
                  style: TextStyle(color: RColors.white),
                )),
            const SizedBox(
              height: 12,
            ),
            Obx(() {
              if (controller.profileLoading.value) {
                // Display a Shimmer loader while user profile is being loaded
                return const RShimmerEffect(width: 80, height: 15);
              } else {
                return Text(
                  controller.user.value.fullName,
                  style: const TextStyle(fontSize: 28, color: RColors.white),
                );
              }
            }),
            Obx(() {
              if (controller.profileLoading.value) {
                // Display a Shimmer loader while user profile is being loaded
                return const RShimmerEffect(width: 80, height: 15);
              } else {
                return Text(
                  controller.user.value.email,
                  style: const TextStyle(fontSize: 16, color: RColors.white),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  buildMenuItems(BuildContext context) {
    final UserRoleController userRoleController = Get.put(UserRoleController());
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.live_help),
            title: const Text("Help & Support"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: () {},
          ),
          const Divider(
            color: RColors.secondary,
          ),
          ListTile(
            leading: const Icon(Icons.switch_account_rounded),
            title: const Text("Customer Mode"),
            onTap: () async {
              String newRole = userRoleController.role.value == 'cleaner'
                  ? 'customer'
                  : 'cleaner';
              try {
                await userRoleController.switchRole(newRole);
                Get.offAll(() => const HomeScreen());
              } catch (e) {
                RLoadersSnackBar.errorSnackBar(
                    title: "Error", message: 'Failed to switch role: $e');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            onTap: () => AuthenticationRepository.instance.logout(),
          ),
        ],
      ),
    );
  }
}
