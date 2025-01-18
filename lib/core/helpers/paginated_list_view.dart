import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int page) onPaginate;
  final int? totalSize;
  final int? page;
  final Widget itemView;
  final double bottomPadding;
  final Widget? loader; // Allow passing a custom loader
  final int itemsPerPage;

  const PaginatedListView({
    super.key,
    required this.scrollController,
    required this.onPaginate,
    required this.totalSize,
    required this.page,
    required this.itemView,
    this.bottomPadding = 40.0,
    this.loader,
    this.itemsPerPage = 10,
  });

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  late int _currentPage;
  bool _isLoading = false;
  final Set<int> _loadedPages = {};

  @override
  void initState() {
    super.initState();
    _currentPage = widget.page ?? 1;
    _loadedPages.add(_currentPage);
  }

  bool _hasMorePages() {
    final totalPageCount = (widget.totalSize! / widget.itemsPerPage).ceil();
    return _currentPage < totalPageCount;
  }

  Future<void> _loadMore() async {
    if (!_loadedPages.contains(_currentPage + 1)) {
      setState(() {
        _isLoading = true;
      });

      _currentPage++;
      _loadedPages.add(_currentPage);

      await widget.onPaginate(_currentPage);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.itemView,
        const SizedBox(height: 16.0), // Adjust space between items and loader
        if (_hasMorePages()) ...[
          VisibilityDetector(
            key: const Key('pagination-detector'),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction > 0.5 && !_isLoading) {
                _loadMore(); // Call pagination when visible
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.loader ??
                  const CircularProgressIndicator(), // Customizable loader
            ),
          ),
        ],
        SizedBox(height: widget.bottomPadding),
      ],
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget? child;
  double? extentSize;

  SliverDelegate({@required this.child, @required this.extentSize});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child!;
  }

  @override
  double get maxExtent => extentSize!;

  @override
  double get minExtent => extentSize!;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != maxExtent ||
        child != oldDelegate.child;
  }
}
