import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:snake_game/utils/app_colors.dart';

class ScoreHistoryWidget extends StatefulWidget {
  final List<(String, int)> scoreHistory;
  const ScoreHistoryWidget({super.key, required this.scoreHistory});

  @override
  State<ScoreHistoryWidget> createState() => _ScoreHistoryWidgetState();
}

class _ScoreHistoryWidgetState extends State<ScoreHistoryWidget> {
  static const _pageSize = 1;

  final PagingController<int, (String, int)> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      if (pageKey == 0) pageKey++;
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = widget.scoreHistory.sublist(
          pageKey, min(widget.scoreHistory.length, pageKey + _pageSize));
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.scoreHistory);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<(String, int)>(
            itemBuilder: (context, item, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (item.$2).toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey2,
                    ),
                  ),
                  Text(
                    item.$1,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
