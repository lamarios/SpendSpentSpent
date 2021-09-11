import 'package:spend_spent_spent/models/pagination.dart';

class PaginatedResults<T> {
  List<T> data = [];
  Pagination pagination;

  PaginatedResults({required this.data, required this.pagination});
}
