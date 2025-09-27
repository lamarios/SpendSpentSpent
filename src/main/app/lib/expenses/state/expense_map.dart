import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

part 'expense_map.freezed.dart';

final _log = Logger('ExpenseMapCubit');

class ExpenseMapCubit extends Cubit<ExpenseMapState> {
  final List<WeightedLatLng> heatmapData;
  final MapController mapController = MapController();
  final CameraFit? defaultFit;
  int? zoom;

  ExpenseMapCubit(super.initialState, this.heatmapData, this.defaultFit) {
    mapController.mapEventStream.listen((event) {
      _log.fine('event ${event.runtimeType}, zoom: ${event.camera.zoom}');

      if (event.camera.zoom.floor() != zoom) {
        emit(
          state.copyWith(
            aggregatedData: aggregateByZoom(heatmapData, event.camera.zoom),
          ),
        );
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

  List<WeightedLatLng> aggregateByZoom(List<WeightedLatLng> data, double zoom) {
    final decimals = decimalsForZoom(zoom);
    final factor = pow(10, decimals);

    final Map<String, List<WeightedLatLng>> buckets = {};
    for (final w in data) {
      final latKey = (w.latLng.latitude * factor).round();
      final lngKey = (w.latLng.longitude * factor).round();
      final key = '$latKey-$lngKey';
      buckets.putIfAbsent(key, () => []).add(w);
    }

    return buckets.values.map((list) {
      final total = list.fold<double>(0, (s, w) => s + w.intensity);
      final avgLat =
          list.map((w) => w.latLng.latitude).reduce((a, b) => a + b) /
          list.length;
      final avgLng =
          list.map((w) => w.latLng.longitude).reduce((a, b) => a + b) /
          list.length;
      return WeightedLatLng(LatLng(avgLat, avgLng), total);
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
    @Default([]) List<WeightedLatLng> aggregatedData,
    @Default(true) bool showHeatmap,
    @Default(true) bool showAmounts,
  }) = _ExpenseMapState;
}
