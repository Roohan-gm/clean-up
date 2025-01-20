import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../models/service_model.dart';
import '../../accepted_cleaner/widgets/custom_icon_button.dart';

class ClientContactCard extends StatelessWidget {
  final String customerName;
  final String customerPhone;
  final List<ServicesModel> serviceDetails;
  final String profileImageUrl;

  const ClientContactCard({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.serviceDetails,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final String services = serviceDetails
        .map((service) => '${service.name} (${service.quantity})')
        .join(", ");

    return Card(
      color: RColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(profileImageUrl),
              onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 35),
              backgroundColor: RColors.secondary.withOpacity(0.1),
            ),
            const SizedBox(height: 10),
            Text(
              customerName,
              style:  const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: RColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              services,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: RColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(
                  elevation: 2,
                  size: 40,
                  color: RColors.primary,
                  xicon: Iconsax.message_text_15,
                  onPressed: () {
                    // Handle message action
                  },
                ),
                CustomIconButton(
                  elevation: 2,
                  size: 40,
                  color: RColors.primary,
                  xicon: CupertinoIcons.phone_fill,
                  onPressed: () {
                    // Handle call action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
