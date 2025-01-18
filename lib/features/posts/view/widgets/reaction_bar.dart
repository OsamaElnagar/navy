import 'package:flutter/material.dart';
import '../../model/reaction_type.dart';
import 'animated_reaction.dart';
import 'package:animate_do/animate_do.dart' as animate;

class ReactionBar extends StatefulWidget {
  final Function(ReactionType) onReactionSelected;
  final double size;

  const ReactionBar({
    super.key,
    required this.onReactionSelected,
    this.size = 32,
  });

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ReactionType.values.map((reaction) {
            return animate.BounceInDown(
              child: AnimatedReaction(
                reaction: reaction,
                isSelected: false,
                onSelected: () => widget.onReactionSelected(reaction),
                size: widget.size,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
