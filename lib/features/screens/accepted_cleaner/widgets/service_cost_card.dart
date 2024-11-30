import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';

class ServiceCostCard extends StatelessWidget {
  const ServiceCostCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: RColors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "2 room , 1 bath",
              style: TextStyle(
                  color: RColors.secondary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "\$180",
              style: TextStyle(
                  color: RColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
