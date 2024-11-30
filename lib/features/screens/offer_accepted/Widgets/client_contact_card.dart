import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../accepted_cleaner/widgets/custom_icon_button.dart';

class ClientContactCard extends StatelessWidget {
  const ClientContactCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: RColors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        leading: CircleAvatar(
          backgroundImage: AssetImage(RImages.avatar),
          radius: 30,
        ),
        title: Text(
          "Jamal",
          textAlign: TextAlign.center,
          style:
          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text(
          "2 room , 1 bath",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: RColors.secondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomIconButton(
              elevation: 5,
              size: 35,
              color: RColors.primary,
              xicon: Iconsax.message_text_15,
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