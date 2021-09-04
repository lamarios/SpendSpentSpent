part of 'graphDataPoint.dart';

GraphDataPoint _$GraphDataPointFromJson(Map<String, dynamic> json) {
  String date;
  try {
    date = json['date'] as String;
  } catch (e) {
    date = (json['date'] as int).toString();
  }

  return GraphDataPoint(
    date: date,
    amount: (json['amount'] as num).toDouble(),
  );
}

Map<String, dynamic> _$GraphDataPointToJson(GraphDataPoint instance) => <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
    };
