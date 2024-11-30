import 'package:flutter/cupertino.dart';

import '../../../../../utils/constants/colors.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Cancel",
        style: TextStyle(
            color: RColors.secondary,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}