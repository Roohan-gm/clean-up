import 'package:clean_up/features/screens/earnings_page/earnings_page.dart';
import 'package:clean_up/features/screens/offer_screen/offer_screen.dart';
import 'package:clean_up/features/screens/order_history/order_history.dart';
import 'package:clean_up/features/screens/rating_screen/rating_screen.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = RHelperFunctions.isDarkMode(context);
    return Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            indicatorShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: darkMode ? RColors.black : RColors.white,
            indicatorColor: darkMode
                ? RColors.white.withOpacity(0.1)
                : RColors.black.withOpacity(0.1),
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.work_outline), label: 'Offers'),
              NavigationDestination(
                  icon: Icon(Icons.attach_money_sharp), label: 'Earnings'),
              NavigationDestination(
                icon: Icon(Icons.star_rate_rounded),
                label: 'Rating',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
          ),
        ),
        body: Obx(
          () => controller.screens[controller.selectedIndex.value],
        ));
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const OfferScreen(),
    const EarningsPage(),
    const RatingScreen(),
    const OrderHistory()
  ];
}
