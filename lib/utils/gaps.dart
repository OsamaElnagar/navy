import 'package:flutter/material.dart';

const gapH4 = SizedBox(height: 4);
const gapH8 = SizedBox(height: 8);
const gapH16 = SizedBox(height: 16);
const gapH20 = SizedBox(height: 20);
const gapH24 = SizedBox(height: 24);
Widget gapH(double height) => SizedBox(height: height);

const gapW4 = SizedBox(width: 4);
const gapW8 = SizedBox(width: 8);
const gapW16 = SizedBox(width: 16);
const gapW20 = SizedBox(width: 20);
const gapW24 = SizedBox(width: 24);
Widget gapW(double width) => SizedBox(width: width);

SizedBox wGap(double width) => SizedBox(width: width);
SizedBox hGap(double height) => SizedBox(height: height);

extension GapExtension on num {
  Widget get h => SizedBox(height: toDouble());
  Widget get w => SizedBox(width: toDouble());
}
