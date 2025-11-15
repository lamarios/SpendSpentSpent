import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/state/expense_list.dart';
import 'package:spend_spent_spent/expenses/state/expense_map.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';

import 'map_expense_list.dart';

class ExpensesMap extends StatelessWidget {
  final Map<String, DayExpense> expenses;

  const ExpensesMap({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        BlocProvider(
          create: (context) => ExpenseMapCubit(ExpenseMapState(), expenses),
          child: BlocBuilder<ExpenseMapCubit, ExpenseMapState>(
            builder: (context, state) {
              final cubit = context.read<ExpenseMapCubit>();
              return state.heatmapData.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.map_outlined, size: 100),
                        Gap(24),
                        Text('No expenses', textAlign: TextAlign.center, style: textTheme.titleLarge),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: bottomPadding - 30, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(bigItemBorderRadius),
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCameraFit: state.fit,
                                  initialCenter: state.center ?? state.heatmapData[0].latLng,
                                ),
                                mapController: context.read<ExpenseMapCubit>().mapController,
                                children: [
                                  TileLayer(
                                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    userAgentPackageName: 'com.spendspentspent.app',
                                  ),
                                  if (state.heatmapData.isNotEmpty && state.showHeatmap)
                                    HeatMapLayer(
                                      heatMapDataSource: InMemoryHeatMapDataSource(data: state.heatmapData),
                                      heatMapOptions: HeatMapOptions(),
                                    ),
                                  if (state.showAmounts)
                                    MarkerLayer(
                                      markers: state.aggregatedData.map((w) {
                                        return Marker(
                                          point: w.location,
                                          width: 80,
                                          height: 40,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () => MapExpenseList.show(context, cluster: w),
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: colors.secondaryContainer.withValues(alpha: 0.8),
                                                  borderRadius: BorderRadius.circular(smallItemBorderRadius),
                                                ),
                                                child: Text(
                                                  formatCurrency(w.total),
                                                  style: TextStyle(
                                                    color: colors.onSecondaryContainer,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                                  title: Text('Heatmap', textAlign: TextAlign.right),
                                  onChanged: cubit.setHeatmap,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SwitchListTile(
                                  value: state.showAmounts,
                                  visualDensity: VisualDensity.compact,
                                  title: Text('Amounts', textAlign: TextAlign.right),
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
