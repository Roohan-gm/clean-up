import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class DistanceCostCard extends StatelessWidget {
  const DistanceCostCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: RColors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          leading: Text(
            "2.9 km",
            style: TextStyle(
                fontSize: 24,
                color: RColors.secondary,
                fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            "\$180",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold),
          )),
    );
  }
}