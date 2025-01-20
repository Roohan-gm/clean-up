import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import 'custom_icon_button.dart';

class CleanerInfoContactCard extends StatelessWidget {
  final String cleanerName;
  final double avgRating;
  final int totalRatings;
  final String profilePicture;
  final String phoneNumber;

  const CleanerInfoContactCard({
    super.key,
    required this.cleanerName,
    required this.avgRating,
    required this.totalRatings,
    required this.profilePicture,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: RColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profilePicture),
              radius: 30,
              onBackgroundImageError: (_, __) => const Icon(Icons.person),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleanerName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.star_fill,
                          color: RColors.primary, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " ($totalRatings ratings)",
                        style: const TextStyle(color: RColors.darkGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconButton(
                  elevation: 2,
                  size: 40,
                  color: RColors.primary,
                  xicon: Iconsax.message_text_15,
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                CustomIconButton(
                  elevation: 2,
                  size: 40,
                  color: RColors.primary,
                  xicon: CupertinoIcons.phone_fill,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
