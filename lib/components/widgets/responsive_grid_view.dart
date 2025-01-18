import 'package:flutter/material.dart';

class ResponsiveGridView<T> extends StatelessWidget {
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final double desiredItemWidth;
  final double desiredItemHeight;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.desiredItemWidth = 220.0,
    this.desiredItemHeight = 180.0,
    this.mainAxisSpacing = 16.0,
    this.crossAxisSpacing = 16.0,
    this.padding,
    this.physics,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth / desiredItemWidth).floor();
        crossAxisCount =
            crossAxisCount.clamp(1, 6); // Limit to between 1 and 6 columns

        double actualItemWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * crossAxisSpacing) /
                crossAxisCount;
        double childAspectRatio = actualItemWidth / desiredItemHeight;

        return GridView.builder(
          shrinkWrap: shrinkWrap,
          physics: physics ?? const NeverScrollableScrollPhysics(),
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) => itemBuilder(context, index),
        );
      },
    );
  }
}
