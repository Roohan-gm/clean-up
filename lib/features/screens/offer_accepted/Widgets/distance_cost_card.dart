import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';

class DistanceCostCard extends StatelessWidget {
  final double distance;
  final String cost;

  const DistanceCostCard({
    super.key,
    required this.distance,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: RColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoColumn(
              value: "${distance.toStringAsFixed(2)} km",
              color: RColors.primary,
            ),
            _infoColumn(
              value: "Rs. $cost",
              color: RColors.black,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for Info Column
  Widget _infoColumn({required String value, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
