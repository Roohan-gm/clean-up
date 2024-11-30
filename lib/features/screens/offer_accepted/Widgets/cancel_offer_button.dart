import 'package:clean_up/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

class CancelOfferButton extends StatelessWidget {
  const CancelOfferButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: TextButton(
        onPressed: () =>Get.off(()=>const NavigationMenu()),
        child: const Text(
          "Cancel",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: RColors.secondary),
        ),
      ),
    );
  }
}