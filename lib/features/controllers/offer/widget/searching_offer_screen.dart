import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class SearchingOfferScreen extends StatelessWidget {
  const SearchingOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: RColors.primary,),
          SizedBox(height: 16),
          Text(
            "Searching for available cleaning services...",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: RColors.black),
          ),
        ],
      ),
    );
  }
}
