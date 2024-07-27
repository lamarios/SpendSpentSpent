import 'package:flutter/material.dart';
import 'package:spend_spent_spent/utils/models/pagination.dart';

class PaginationSwitcher extends StatelessWidget {
  final Pagination pagination;
  final Function previous, next;

  const PaginationSwitcher(
      {super.key,
      required this.pagination,
      required this.previous,
      required this.next});

  @override
  Widget build(BuildContext context) {
    bool hasNext = pagination.totalPages > 1 &&
        pagination.page < pagination.totalPages - 1;
    bool hasPrevious = pagination.totalPages > 1 && pagination.page > 0;

    print(
        'total pages: ${pagination.totalPages}, page ${pagination.page} hasNext $hasNext');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: hasPrevious ? () => previous() : null,
            child: Icon(
              Icons.chevron_left,
              color: hasPrevious ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Text('${pagination.page + 1}/${pagination.totalPages}')),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: hasNext ? () => next() : null,
            child: Icon(
              Icons.chevron_right,
              color: hasNext ? Theme.of(context).primaryColor : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
