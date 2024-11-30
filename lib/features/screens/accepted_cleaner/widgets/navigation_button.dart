import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 150,
        margin: const EdgeInsets.all(10),
        child: Material(
            color: RColors.white,
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  iconSize: 35,
                  icon: const Icon(
                    CupertinoIcons.location_fill,
                    color: RColors.primary,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "Navigate",
                  style: TextStyle(
                      fontSize: 20,
                      color: RColors.primary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }
}
