// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:navy/models/pagination.dart';

class PaginationHelper extends StatefulWidget {
  const PaginationHelper({
    super.key,
    required this.pagination,
  });

  final Pagination pagination;

  @override
  State<PaginationHelper> createState() => _PaginationHelperState();
}

class _PaginationHelperState extends State<PaginationHelper>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController = ScrollController(
      keepScrollOffset: true,
      initialScrollOffset: widget.pagination.currentPage.toDouble(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
