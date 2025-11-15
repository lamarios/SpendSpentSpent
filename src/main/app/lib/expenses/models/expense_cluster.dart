import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'expense.dart';

part 'expense_cluster.freezed.dart';

@freezed
sealed class ExpenseCluster with _$ExpenseCluster {
  const factory ExpenseCluster({@Default([]) List<Expense> expenses, required double total, required LatLng location}) =
      _ExpenseCluster;
}
