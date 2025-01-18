import 'package:flutter/material.dart';

class AdvancedNavigationBar extends StatefulWidget {
  final List<NavigationItem> items;
  final Function(int) onTabChanged;
  final double ringDiameter;
  final Color ringColor;
  final Color activeColor;
  final Color inactiveColor;

  const AdvancedNavigationBar({
    super.key,
    required this.items,
    required this.onTabChanged,
    this.ringDiameter = 70,
    this.ringColor = Colors.red,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<AdvancedNavigationBar> createState() => _AdvancedNavigationBarState();
}

class _AdvancedNavigationBarState extends State<AdvancedNavigationBar> {
  late ScrollController _scrollController;
  late int _currentIndex;
  final double _itemWidth = 70.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = 1;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(_currentIndex);
    });
  }

  void _scrollToIndex(int index) {
    if (!mounted) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final targetPosition =
        (index * _itemWidth) - (screenWidth - _itemWidth) / 2;

    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _onScroll() {
    final screenWidth = MediaQuery.of(context).size.width;
    final centerPosition = _scrollController.offset + (screenWidth / 2);
    final index = (centerPosition / _itemWidth).round();

    if (index != _currentIndex && index >= 0 && index < widget.items.length) {
      setState(() {
        _currentIndex = index;
        widget.onTabChanged(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 90,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fixed Ring
          Container(
            width: widget.ringDiameter,
            height: widget.ringDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: widget.ringColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.ringColor.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Scrollable Items
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                _onScroll();
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: (screenWidth - _itemWidth) / 2,
              ),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final isActive = index == _currentIndex;
                final item = widget.items[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      widget.onTabChanged(index);
                      _scrollToIndex(index);
                    });
                  },
                  child: SizedBox(
                    width: _itemWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isActive ? 60 : 50,
                          height: isActive ? 60 : 50,
                          decoration: BoxDecoration(
                            color: isActive
                                ? widget.activeColor
                                : widget.inactiveColor,
                            shape: BoxShape.circle,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color:
                                          widget.activeColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: isActive ? 30 : 24,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: widget.activeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
