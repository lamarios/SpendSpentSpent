import 'package:json_annotation/json_annotation.dart';

part 'graphDataPoint.g.dart';

class GraphDataPoint{
  String date;
  double amount;
  GraphDataPoint({required this.date, required this.amount});

  factory GraphDataPoint.fromJson(Map<String, dynamic> json) => _$GraphDataPointFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GraphDataPointToJson(this);
}