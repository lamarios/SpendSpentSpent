import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/models/expense_cluster.dart';

import '../models/expense.dart';

part 'expense_map.freezed.dart';

final _log = Logger('ExpenseMapCubit');

class ExpenseMapCubit extends Cubit<ExpenseMapState> {
  final Map<String, DayExpense> expenses;
  final MapController mapController = MapController();
  int? zoom;

  ExpenseMapCubit(super.initialState, this.expenses) {
    init();
  }

  void init() {
    var expenseList = expenses.values.expand((e) => e.expenses).where((exp) => exp.hasLocation).toList();
    expenseList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (expenseList.isEmpty) {
      emit(state.copyWith(fit: null));
      return;
    }

    List<LatLng> points = [];
    List<WeightedLatLng> heatmapData = [];
    CameraFit? fit;
    LatLng? center;

    for (var exp in expenseList) {
      var latitude = exp.latitude!;
      var longitude = exp.longitude!;
      var latLng = LatLng(latitude, longitude);
      heatmapData.add(WeightedLatLng(latLng, exp.amount));
      points.add(latLng);
    }
    if (expenseList.length > 1) {
      fit = CameraFit.bounds(bounds: LatLngBounds.fromPoints(points), padding: EdgeInsets.all(50));
      center = null;
    } else {
      center = points[0];
      fit = null;
    }

    emit(state.copyWith(heatmapData: heatmapData, fit: fit, center: center));

    mapController.mapEventStream.listen((event) {
      _log.fine('event ${event.runtimeType}, zoom: ${event.camera.zoom}');

      if (event.camera.zoom.floor() != zoom) {
        emit(state.copyWith(aggregatedData: aggregateByZoom(expenseList, event.camera.zoom)));
      }

      zoom = event.camera.zoom.floor();
    });
  }

  @override
  close() async {
    mapController.dispose();
    super.close();
  }

  int decimalsForZoom(double zoom) {
    if (zoom <= 5) return 0;
    if (zoom <= 8) return 0;
    if (zoom <= 10) return 0;
    if (zoom <= 12) return 1;
    if (zoom <= 15) return 2;
    if (zoom <= 19) return 3;
    if (zoom <= 20) return 4;
    return 6;
  }

  List<ExpenseCluster> aggregateByZoom(List<Expense> data, double zoom) {
    final decimals = decimalsForZoom(zoom);
    final factor = pow(10, decimals);

    final Map<String, List<Expense>> buckets = {};
    for (final w in data) {
      final latKey = (w.latitude! * factor).round();
      final lngKey = (w.longitude! * factor).round();
      final key = '$latKey-$lngKey';
      buckets.putIfAbsent(key, () => []).add(w);
    }

    return buckets.values.map((list) {
      final total = list.fold<double>(0, (s, w) => s + w.amount);
      final avgLat = list.map((w) => w.latitude!).reduce((a, b) => a + b) / list.length;
      final avgLng = list.map((w) => w.longitude!).reduce((a, b) => a + b) / list.length;
      return ExpenseCluster(location: LatLng(avgLat, avgLng), total: total, expenses: list);
    }).toList();
  }

  void setHeatmap(bool value) {
    emit(state.copyWith(showHeatmap: value));
  }

  void setAmounts(bool val) {
    emit(state.copyWith(showAmounts: val));
  }
}

@freezed
sealed class ExpenseMapState with _$ExpenseMapState {
  const factory ExpenseMapState({
    @Default([]) List<ExpenseCluster> aggregatedData,
    @Default([]) List<WeightedLatLng> heatmapData,
    @Default(true) bool showHeatmap,
    @Default(true) bool showAmounts,
    CameraFit? fit,
    LatLng? center,
  }) = _ExpenseMapState;
}
