import 'package:flutter/cupertino.dart';

import '../../utils/constants/sizes.dart';

class RSpacingStyle{
  static EdgeInsetsGeometry paddingWithAppBarHeight =  const EdgeInsets.only(
    top: RSizes.appBarHeight,
    left: RSizes.defaultSpacing,
    bottom: RSizes.defaultSpacing,
    right: RSizes.defaultSpacing,
  );
}