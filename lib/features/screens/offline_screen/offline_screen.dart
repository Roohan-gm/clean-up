import 'package:flutter/cupertino.dart';

import '../../../utils/constants/colors.dart';

class OfflineScreen  extends StatelessWidget{
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:  EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You are currently offline...",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: RColors.black),
          ),
          Text(
            "No Active orders for you at the moment.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: RColors.secondary),
          ),
        ],
      ),
    );
  }
}