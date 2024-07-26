// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      page: (json['page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      currentPageCount: (json['currentPageCount'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'totalPages': instance.totalPages,
      'currentPageCount': instance.currentPageCount,
      'page': instance.page,
      'total': instance.total,
      'pageSize': instance.pageSize,
    };
