import 'package:flutter/material.dart';

typedef PopUpBuilder = Widget Function(
  BuildContext context,
  Offset position,
  Size size,
);

class AppPopupMenu extends StatelessWidget {
  const AppPopupMenu({
    super.key,
    required this.child,
    required this.popUpBuilder,
  });

  final Widget child;
  final PopUpBuilder popUpBuilder;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          barrierDismissible: false,
          builder: (context) {
            RenderBox renderBox = (child.key as GlobalKey)
                .currentContext
                ?.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            return popUpBuilder(context, position, renderBox.size);
          },
        );
      },
      icon: child,
    );
  }
}
