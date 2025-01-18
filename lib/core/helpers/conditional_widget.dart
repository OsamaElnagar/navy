import 'package:flutter/material.dart';

class ConditionalWidget extends StatefulWidget {
  final bool condition;
  final WidgetBuilder builder;
  final WidgetBuilder fallback;
  final WidgetBuilder? loading;
  final WidgetBuilder? errorBuilder;
  final bool cache;
  final bool isLoading;
  final Duration? transitionDuration;
  final Curve curve;

  const ConditionalWidget({
    super.key,
    required this.condition,
    required this.builder,
    required this.fallback,
    this.loading,
    this.errorBuilder,
    this.cache = false,
    this.isLoading = false,
    this.transitionDuration,
    this.curve = Curves.easeInOut,
  });

  @override
  State<ConditionalWidget> createState() => _ConditionalWidgetState();
}

class _ConditionalWidgetState extends State<ConditionalWidget> {
  Widget? cachedWidget;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.loading != null) {
      return widget.loading!(context);
    }

    try {
      // Check if caching is enabled and the widget has already been built
      if (widget.cache && cachedWidget != null) {
        return cachedWidget!;
      }

      Widget content = widget.condition ? widget.builder(context) : widget.fallback(context);

      // Cache the widget if caching is enabled
      if (widget.cache) {
        cachedWidget = content;
      }

      if (widget.transitionDuration != null) {
        return AnimatedSwitcher(
          duration: widget.transitionDuration!,
          switchInCurve: widget.curve,
          switchOutCurve: widget.curve,
          child: content,
        );
      }

      return content;
    } catch (e) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context);
      }
      return Center(child: Text('An error occurred: $e'));
    }
  }
}
