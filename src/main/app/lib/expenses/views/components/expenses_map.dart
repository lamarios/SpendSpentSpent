import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/state/expense_list.dart';
import 'package:spend_spent_spent/expenses/state/expense_map.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';

class ExpensesMap extends StatelessWidget {
  final List<WeightedLatLng> heatmapData = [];
  late final CameraFit? fit;
  late final LatLng? center;

  ExpensesMap({super.key, required Map<String, DayExpense> expenses}) {
    var expenseList = expenses.values
        .expand((e) => e.expenses)
        .where((exp) => exp.latitude != 0 && exp.longitude != 0);
    if (expenseList.isEmpty) {
      fit = null;
      return;
    }

    List<LatLng> points = [];

    for (var exp in expenseList) {
      var latitude = exp.latitude!;
      var longitude = exp.longitude!;
      var latLng = LatLng(latitude, longitude);
      heatmapData.add(WeightedLatLng(latLng, exp.amount));
      points.add(latLng);
    }
    if (expenseList.length > 1) {
      fit = CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: EdgeInsets.all(50),
      );
      center = null;
    } else {
      center = points[0];
      fit = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        heatmapData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.map_outlined, size: 100),
                  Gap(24),
                  Text(
                    'No expenses',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge,
                  ),
                ],
              )
            : BlocProvider(
                create: (context) =>
                    ExpenseMapCubit(ExpenseMapState(), heatmapData, fit),
                child: BlocBuilder<ExpenseMapCubit, ExpenseMapState>(
                  builder: (context, state) {
                    final cubit = context.read<ExpenseMapCubit>();
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: bottomPadding - 30,
                        top: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                bigItemBorderRadius,
                              ),
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCameraFit: fit,
                                  initialCenter:
                                      center ?? heatmapData[0].latLng,
                                ),
                                mapController: context
                                    .read<ExpenseMapCubit>()
                                    .mapController,
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    userAgentPackageName:
                                        'com.spendspentspent.app',
                                  ),
                                  if (heatmapData.isNotEmpty &&
                                      state.showHeatmap)
                                    HeatMapLayer(
                                      heatMapDataSource:
                                          InMemoryHeatMapDataSource(
                                            data: heatmapData,
                                          ),
                                      heatMapOptions: HeatMapOptions(),
                                    ),
                                  if (state.showAmounts)
                                    MarkerLayer(
                                      markers: state.aggregatedData.map((w) {
                                        return Marker(
                                          point: w.latLng,
                                          width: 80,
                                          height: 40,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: colors.secondaryContainer
                                                    .withValues(alpha: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      smallItemBorderRadius,
                                                    ),
                                              ),
                                              child: Text(
                                                formatCurrency(w.intensity),
                                                style: TextStyle(
                                                  color: colors
                                                      .onSecondaryContainer,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: SwitchListTile(
                                  value: state.showHeatmap,
                                  visualDensity: VisualDensity.compact,
                                  title: Text(
                                    'Heatmap',
                                    textAlign: TextAlign.right,
                                  ),
                                  onChanged: cubit.setHeatmap,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SwitchListTile(
                                  value: state.showAmounts,
                                  visualDensity: VisualDensity.compact,
                                  title: Text(
                                    'Amounts',
                                    textAlign: TextAlign.right,
                                  ),
                                  onChanged: cubit.setAmounts,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

        Positioned(
          right: 10,
          top: 20,
          child: IconButton.filledTonal(
            visualDensity: VisualDensity.compact,
            iconSize: 15,
            onPressed: () => context.read<ExpenseListCubit>().toggleMap(),
            icon: Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
