import 'package:flutter/material.dart';

class PopupMenuOverlay extends StatelessWidget {
  final List<PopupMenuItem> items;
  final VoidCallback onDismiss;
  final double? width;
  final EdgeInsets? padding;

  const PopupMenuOverlay({
    super.key,
    required this.items,
    required this.onDismiss,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }
}
