// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'dart:math' show max;

enum PMPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomRight,
  center
}

enum PMAxisDirection { vertical, horizontal }

enum PMTrigger { tap, longPress, both }

class PopupMenuWrapper extends StatefulWidget {
  final Widget child;
  final List<PopupMenuEntry> menuItems;
  final Function(dynamic value)? onSelected;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double elevation;
  final PMPosition preferredPosition;
  final double offset;
  final bool showArrow;
  final Color? arrowColor;
  final bool barrierDismissible;
  final Color? barrierColor;
  final BoxConstraints? constraints;
  final PMAxisDirection axisDirection;
  final double? menuWidth;
  final PMTrigger trigger;

  const PopupMenuWrapper({
    super.key,
    required this.child,
    required this.menuItems,
    this.onSelected,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.elevation = 8.0,
    this.preferredPosition = PMPosition.bottomRight,
    this.offset = 4.0,
    this.showArrow = false,
    this.arrowColor,
    this.barrierDismissible = true,
    this.barrierColor = Colors.transparent,
    this.constraints,
    this.axisDirection = PMAxisDirection.vertical,
    this.menuWidth,
    this.trigger = PMTrigger.tap,
    this.margin,
  });

  @override
  State<PopupMenuWrapper> createState() => _PopupMenuWrapperState();
}

class _PopupMenuWrapperState extends State<PopupMenuWrapper> {
  OverlayEntry? _overlayEntry;
  bool _isMenuVisible = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isMenuVisible = false;
  }

  void _showOverlay(BuildContext context, TapDownDetails? details) {
    _removeOverlay();

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final buttonSize = button.size;

    // Calculate position based on preferred position
    Offset position = _calculatePosition(
      buttonPosition,
      buttonSize,
      overlay.size,
      widget.preferredPosition,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Barrier
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.barrierDismissible ? _removeOverlay : null,
              behavior: HitTestBehavior.opaque,
              child: Container(color: widget.barrierColor),
            ),
          ),
          // Menu
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Material(
              color: Colors.transparent,
              child: TweenAnimationBuilder<double>(
                duration: widget.animationDuration,
                curve: widget.animationCurve,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: _buildMenuContent(position, buttonPosition, buttonSize),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isMenuVisible = true;
  }

  Widget _buildMenuContent(
      Offset position, Offset buttonPosition, Size buttonSize) {
    return Container(
      constraints: widget.constraints ??
          BoxConstraints(
            maxWidth: widget.menuWidth ?? 200,
            minWidth: widget.menuWidth ?? 120,
          ),
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: widget.elevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: widget.padding,
      margin: widget.margin,
      child: widget.axisDirection == PMAxisDirection.vertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showArrow) _buildArrow(),
                ...widget.menuItems.map((item) => _buildMenuItem(item)),
              ],
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showArrow) _buildArrow(),
                  ...widget.menuItems.map((item) => _buildMenuItem(item)),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem(PopupMenuEntry item) {
    if (item is PopupMenuItem) {
      return InkWell(
        onTap: () {
          _removeOverlay();
          widget.onSelected?.call(item.value);
        },
        child: Container(
          //color: Theme.of(context).scaffoldBackgroundColor,
          padding: widget.padding,
          child: item.child,
        ),
      );
    }
    return item;
  }

  Widget _buildArrow() {
    return CustomPaint(
      size: const Size(12, 6),
      painter: ArrowPainter(
        color: widget.arrowColor ??
            widget.backgroundColor ??
            Theme.of(context).cardColor,
      ),
    );
  }

  Offset _calculatePosition(
    Offset buttonPosition,
    Size buttonSize,
    Size overlaySize,
    PMPosition position,
  ) {
    double dx = 0.0;
    double dy = 0.0;
    double menuWidth = widget.menuWidth ?? 200;
    double menuHeight = 300; // Add estimated menu height

    switch (position) {
      case PMPosition.topLeft:
        dx = buttonPosition.dx;
        dy = buttonPosition.dy - widget.offset;
        break;
      case PMPosition.topCenter:
        dx = buttonPosition.dx + (buttonSize.width / 2) - (menuWidth / 2);
        dy = buttonPosition.dy - widget.offset;
        break;
      case PMPosition.topRight:
        dx = buttonPosition.dx + buttonSize.width - menuWidth;
        dy = buttonPosition.dy - widget.offset;
        break;
      case PMPosition.bottomLeft:
        dx = buttonPosition.dx;
        dy = buttonPosition.dy + buttonSize.height + widget.offset;
        break;
      case PMPosition.bottomRight:
        dx = buttonPosition.dx + buttonSize.width - menuWidth;
        dy = buttonPosition.dy + buttonSize.height + widget.offset;
        break;
      case PMPosition.center:
        dx = buttonPosition.dx + (buttonSize.width - menuWidth) / 2;
        dy = buttonPosition.dy + buttonSize.height + widget.offset;
        break;
    }

    // Ensure menu stays within screen bounds with proper minimum values
    dx = dx.clamp(0.0, max(0.0, overlaySize.width - menuWidth));
    dy = dy.clamp(0.0, max(0.0, overlaySize.height - menuHeight));

    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          (widget.trigger == PMTrigger.tap || widget.trigger == PMTrigger.both)
              ? (details) => _showOverlay(context, details)
              : null,
      onLongPress: (widget.trigger == PMTrigger.longPress ||
              widget.trigger == PMTrigger.both)
          ? () => _showOverlay(context, null)
          : null,
      child: widget.child,
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Color color;

  ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
