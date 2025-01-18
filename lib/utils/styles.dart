import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dimensions.dart';

const ubuntuLight = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w300,
);

const ubuntuRegular = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w400,
);

const ubuntuMedium = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w500,
);

const ubuntuBold = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w700,
);

List<BoxShadow>? searchBoxShadow = Get.isDarkMode
    ? null
    : [
        const BoxShadow(
            offset: Offset(0, 3),
            color: Color(0x208F94FB),
            blurRadius: 5,
            spreadRadius: 2)
      ];

//card boxShadow
List<BoxShadow>? cardShadow = Get.isDarkMode
    ? [const BoxShadow()]
    : [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 2,
          color: Colors.black.withOpacity(0.08),
        )
      ];

List<BoxShadow>? cardShadow2 = Get.isDarkMode
    ? [const BoxShadow()]
    : [
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 2,
          color: const Color(0xFF0461A5).withOpacity(0.15),
        )
      ];

List<BoxShadow>? lightShadow = Get.isDarkMode
    ? [const BoxShadow()]
    : [
        const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 1,
          color: Color(0x20D6D8E6),
        )
      ];

List<BoxShadow>? shadow = Get.isDarkMode
    ? [const BoxShadow()]
    : [
        BoxShadow(
            offset: const Offset(0, 3),
            color: Colors.grey[100]!,
            blurRadius: 1,
            spreadRadius: 2)
      ];

Decoration shimmerDecorationGreySoft = BoxDecoration(
  color: Colors.grey[Get.isDarkMode ? 700 : 300],
  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
);

Decoration shimmerDecorationGreyHard = BoxDecoration(
  color: Colors.grey[Get.isDarkMode ? 700 : 400],
  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
);
