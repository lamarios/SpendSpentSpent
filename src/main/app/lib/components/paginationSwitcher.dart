import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/models/pagination.dart';

class PaginationSwitcher extends StatelessWidget {
  final Pagination pagination;
  final Function previous, next;

  const PaginationSwitcher(
      {required this.pagination, required this.previous, required this.next});

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
            child: FaIcon(
              FontAwesomeIcons.chevronLeft,
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
            child: FaIcon(
              FontAwesomeIcons.chevronRight,
              color: hasNext ? Theme.of(context).primaryColor : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
