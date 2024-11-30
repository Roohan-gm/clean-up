import 'package:clean_up/features/screens/home/widgets/product_tile.dart';
import 'package:clean_up/features/screens/home/widgets/service_completion_essential.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';

class BottomServiceSheet extends StatelessWidget {
  const BottomServiceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 800,
        padding: const EdgeInsets.only(top: 20),
        color: RColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 670,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 1; i < 3; i++)
                        ProductTile(i: i),
                      const ServiceCompletionEssential(),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}



