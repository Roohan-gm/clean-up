import 'package:clean_up/app_controller.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/image_strings.dart';
import '../offline_screen/offline_screen.dart';
import '../online_screen/online_screen.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Iconsax.element_plus,
                size: 36,
                color: RColors.primary,
              ));
        }),
        title: Switch(
          value: isOnline,
          onChanged: (value) {
            setState(() {
              isOnline = value;
            });
          },
          activeColor: RColors.primary,
          trackOutlineColor: const WidgetStatePropertyAll(RColors.white),
          thumbColor: const WidgetStatePropertyAll(RColors.white),
          inactiveTrackColor: RColors.secondary,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: const DecorationImage(
                      image: AssetImage(RImages.avatar), fit: BoxFit.cover),
                )),
          )
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: isOnline ? const OnlineScreen() : const OfflineScreen(),
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
            title: const Text("User Mode"),
            onTap: (){
              final appController = Get.find<AppController>();
              appController.switchMode('user');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
