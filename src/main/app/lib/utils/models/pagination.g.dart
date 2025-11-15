// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pagination _$PaginationFromJson(Map<String, dynamic> json) => _Pagination(
  page: (json['page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  currentPageCount: (json['currentPageCount'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(_Pagination instance) => <String, dynamic>{
  'page': instance.page,
  'total': instance.total,
  'currentPageCount': instance.currentPageCount,
  'pageSize': instance.pageSize,
  'totalPages': instance.totalPages,
};
