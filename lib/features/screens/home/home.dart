import 'package:clean_up/common/widgets/appbar/appbar.dart';
import 'package:clean_up/features/screens/home/widgets/all_services.dart';
import 'package:clean_up/features/screens/home/widgets/bottom_service_sheet.dart';
import 'package:clean_up/features/screens/login/login.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/constants/sizes.dart';
import 'package:clean_up/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sliding_sheet2/sliding_sheet2.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../app_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: const DecorationImage(
                              image: AssetImage(RImages.avatar),
                              fit: BoxFit.cover),
                        ))
                  ],
                  title: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          RTexts.homeAppbarTitle,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(color: RColors.grey),
                        ),
                        Text(
                          RTexts.homeAppbarTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .apply(color: RColors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(RSizes.defaultSpacing),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      RTexts.homeTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.start,
                    )),
              ),
              const AllServices(),
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
                            return const BottomServiceSheet();
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
                          RTexts.checkout,
                          style: TextStyle(
                              fontSize: 25,
                              color: RColors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          CupertinoIcons.arrow_right,
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

class CustomHomeNavigationDrawer extends StatefulWidget {
  const CustomHomeNavigationDrawer({super.key});

  @override
  State<CustomHomeNavigationDrawer> createState() => _CustomHomeNavigationDrawerState();
}

class _CustomHomeNavigationDrawerState extends State<CustomHomeNavigationDrawer> {
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
    return Material(
      color: RColors.primary,
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, bottom: 24),
        child: const Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(RImages.avatar),
              radius: 52,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Jamal",
              style: TextStyle(fontSize: 28, color: RColors.white),
            ),
            Text(
              "l1f19bsse0004@gmail.com",
              style: TextStyle(fontSize: 16, color: RColors.white),
            )
          ],
        ),
      ),
    );
  }

  buildMenuItems(BuildContext context) {
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
            onTap: (){
              final appController = Get.find<AppController>();
              appController.switchMode('cleaner');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            onTap: () async {
              // await supabase.auth.signOut();
              if(!mounted) return;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
