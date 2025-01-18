import 'package:flutter/material.dart';

class DividerX extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color color;

  const DividerX({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.indent = 2,
    this.endIndent = 2,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}

class DividerY extends StatelessWidget {
  final double width;
  final double thickness;
  final double startIndent;
  final double endIndent;
  final Color color;

  const DividerY({
    super.key,
    this.width = 1,
    this.thickness = 1,
    this.startIndent = 2,
    this.endIndent = 2,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      child: RotatedBox(
        quarterTurns: 1,
        child: Divider(
          height: width,
          thickness: thickness,
          indent: startIndent,
          endIndent: endIndent,
          color: color,
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;
  final Axis axis;
  const CustomDivider(
      {super.key,
      this.height = 1,
      this.dashWidth = 5,
      this.color = Colors.black,
      this.axis = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize = axis == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashHeight = height;
        final dashCount = (boxSize / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: axis,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: axis == Axis.horizontal ? dashWidth : dashHeight,
              height: axis == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
