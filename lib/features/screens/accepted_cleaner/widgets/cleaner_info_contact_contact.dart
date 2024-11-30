
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import 'custom_icon_button.dart';

class CleanerInfoContactCard extends StatelessWidget {
  const CleanerInfoContactCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: RColors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(RImages.avatar),
          radius: 30,
        ),
        title: Text(
          "Jamal",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Row(
          children: [
            Icon(
              CupertinoIcons.star_fill,
              color: RColors.primary,
              size: 15,
            ),
            SizedBox(width: 5),
            Text(
              "4.2",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: RColors.black,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "(2,342)",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: RColors.darkGrey,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconButton(
              elevation: 5,
              size: 35,
              color: RColors.primary,
              xicon: Iconsax.message_text_15,
            ),
            SizedBox(
              width: 5,
            ),
            CustomIconButton(
              elevation: 5,
              size: 35,
              color: RColors.primary,
              xicon: CupertinoIcons.phone_fill,
            ),
          ],
        ),
      ),
    );
  }
}

