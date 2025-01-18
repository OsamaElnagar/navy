import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';

class UiConstantsHelper {
  static final BorderRadiusGeometry defaultBorderRadius  =
      BorderRadius.circular(Dimensions.radiusDefault);

  static const EdgeInsets defaultPadding =
      EdgeInsets.all(Dimensions.paddingSizeDefault);

  static const EdgeInsets defaultMargin =
      EdgeInsets.all(Dimensions.paddingSizeSmall);
}
