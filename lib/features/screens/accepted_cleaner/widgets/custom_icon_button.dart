import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class CustomIconButton extends StatelessWidget {
  final double elevation;
  final double size;
  final Color color;
  final IconData xicon;
  final Callback? onPressed;

  const CustomIconButton({
    super.key,
    required this.elevation,
    required this.size,
    required this.color,
    required this.xicon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RColors.white,
      // elevation: elevation,
      // shape: const CircleBorder(),
      child: IconButton(
        iconSize: size,
        icon: Icon(xicon, color: color,),
        onPressed: onPressed,
      ),
    );
  }
}
