import 'package:clean_up/common/widgets/appbar/appbar.dart';
import 'package:clean_up/features/controllers/user/user_controller.dart';
import 'package:clean_up/features/controllers/user_role/user_role_controller.dart';
import 'package:clean_up/features/screens/home/widgets/bottom_service_sheet.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/constants/sizes.dart';
import 'package:clean_up/utils/constants/text_strings.dart';
import 'package:clean_up/utils/images/circular_image.dart';
import 'package:clean_up/utils/popups/loaders.dart';
import 'package:clean_up/utils/popups/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sliding_sheet2/sliding_sheet2.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/services_cart/services_cart_repositories.dart';
import '../../../navigation_menu.dart';
import '../../controllers/services/services_controller.dart';
import '../../controllers/services_cart/services_cart_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceController = Get.find<ServicesController>();
    final servicesCartController = Get.find<ServicesCartController>();
    final UserController userController = Get.find<UserController>();

    // Optionally lazy load the cart only when needed
    Get.lazyPut(
        () => ServicesCartController(Get.find<ServicesCartRepository>()),
        fenix: true);

    return Scaffold(
      drawer: const CustomHomeNavigationDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Builder(
                builder: (context) => RAppbar(
                  leadingIcon: Iconsax.element_plus,
                  leadingOnPressed: () => Scaffold.of(context).openDrawer(),
                  actions: [
                    Obx(() {
                      final networkImage =
                          userController.user.value.profilePicture;
                      final image =
                          networkImage.isNotEmpty ? networkImage : RImages.user;

                      return userController.imageUploading.value
                          ? const RShimmerEffect(
                              width: 50,
                              height: 50,
                              radius: 50,
                            )
                          : RCircularImage(
                              image: image,
                              isNetworkImage: networkImage.isNotEmpty,
                              width: 50,
                              height: 50,
                            );
                    }),
                  ],
                  title: Center(
                    child: Obx(() {
                      if (userController.profileLoading.value) {
                        // Display a Shimmer loader while user profile is being loaded
                        return const RShimmerEffect(width: 80, height: 15);
                      } else {
                        return Text(
                          userController.user.value.fullName,
                          style: const TextStyle(
                              fontSize: 28, color: RColors.white),
                        );
                      }
                    }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: RSizes.defaultSpacing, vertical: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      RTexts.homeTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.start,
                    )),
              ),
              Obx(() {
                if (serviceController.services.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: RColors.primary,
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        (MediaQuery.of(context).size.width * 0.4) /
                            (MediaQuery.of(context).size.height * 0.29),
                  ),
                  itemCount: serviceController.services.length,
                  itemBuilder: (context, index) {
                    final service = serviceController.services[index];
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: RColors.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: RColors.darkGrey,
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              service.image,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                service.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: RColors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              service.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: RColors.darkGrey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs.${service.price}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: RColors.primary,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    servicesCartController
                                        .addItemToCart(service);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: RColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: RColors.black.withOpacity(0.2),
                                      //     spreadRadius: 1,
                                      //     blurRadius: 3,
                                      //     offset: const Offset(2, 2),
                                      //   ),
                                      // ],
                                    ),
                                    child: const Icon(
                                      Icons.add_shopping_cart,
                                      color: RColors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    showSlidingBottomSheet(context, builder: (context) {
                      return SlidingSheetDialog(
                          elevation: 8,
                          cornerRadius: 16,
                          snapSpec: const SnapSpec(
                              snap: true,
                              snappings: [0.8],
                              positioning:
                                  SnapPositioning.relativeToAvailableSpace),
                          builder: (context, state) {
                            final servicesCartController =
                                Get.find<ServicesCartController>();
                            return BottomServiceSheet(
                              servicesCartController: servicesCartController,
                            );
                          });
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(RColors.primary),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          RTexts.cart,
                          style: TextStyle(
                              fontSize: 25,
                              color: RColors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          CupertinoIcons.shopping_cart,
                          color: RColors.white,
                          size: 35,
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomHomeNavigationDrawer extends StatelessWidget {
  const CustomHomeNavigationDrawer({super.key});

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
            title: const Text("Cleaner Mode"),
            onTap: () async {
              String newRole = userRoleController.role.value == 'customer'
                  ? 'cleaner'
                  : 'customer';
              try {
                await userRoleController.switchRole(newRole);
                Get.offAll(() => const NavigationMenu());
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
