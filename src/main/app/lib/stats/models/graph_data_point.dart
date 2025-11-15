class GraphDataPoint {
  final String date;
  final double amount;

  const GraphDataPoint({required this.date, required this.amount});

  static GraphDataPoint fromJson(Map<String, dynamic> json) {
    String date;
    try {
      date = json['date'] as String;
    } catch (e) {
      date = (json['date'] as int).toString();
    }

    return GraphDataPoint(date: date, amount: (json['amount'] as num).toDouble());
  }

  static Map<String, dynamic> toJson(GraphDataPoint instance) => <String, dynamic>{
    'date': instance.date,
    'amount': instance.amount,
  };
}
