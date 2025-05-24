import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.g.dart';

part 'pagination.freezed.dart';

@freezed
sealed class Pagination with _$Pagination {
  const factory Pagination(
      {required int page,
      required int total,
      required int currentPageCount,
      required int pageSize,
      required int totalPages}) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
