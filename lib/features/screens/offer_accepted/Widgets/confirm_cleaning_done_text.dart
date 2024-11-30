import 'package:flutter/cupertino.dart';

class ConfirmCleaningDoneText extends StatelessWidget {
  const ConfirmCleaningDoneText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Are you done with your cleaning?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}