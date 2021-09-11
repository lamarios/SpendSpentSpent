// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) {
  return Pagination(
    page: json['page'] as int,
    total: json['total'] as int,
    currentPageCount: json['currentPageCount'] as int,
    pageSize: json['pageSize'] as int,
    totalPages: json['totalPages'] as int,
  );
}

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'totalPages': instance.totalPages,
      'currentPageCount': instance.currentPageCount,
      'page': instance.page,
      'total': instance.total,
      'pageSize': instance.pageSize,
    };
