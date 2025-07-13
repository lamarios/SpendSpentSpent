import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';

import '../../models/expense.dart';

class ExpenseMenu extends StatelessWidget {
  final Expense expense;

  const ExpenseMenu({super.key, required this.expense});

  static showSheet(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Wrap(
            children: [
              ExpenseMenu(expense: expense),
            ],
          ),
        );
      },
    );
  }

  showDeleteExpenseDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Delete Expense ?'),
              content: const Text(
                  'This will only delete this expense, it is not recoverable.'),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: colors.secondary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    deleteExpense(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  deleteExpense(BuildContext context) async {
    await service.deleteExpense(expense.id!);
    if (context.mounted) {
      context.read<LastExpenseCubit>().refresh();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasMap = expense.latitude != 0 && expense.longitude != 0;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasMap) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  width: min(700, constraints.maxWidth),
                  height: min(500, constraints.maxHeight),
                  child: FlutterMap(
                    options: MapOptions(
                        initialZoom: 15,
                        initialCenter: LatLng(
                            (expense.latitude ?? 0), expense.longitude ?? 0)),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.spendspentspent.app',
                      ),
                      MarkerLayer(markers: [
                        Marker(
                            width: 40.0,
                            height: 40.0,
                            point: LatLng(
                                expense.latitude ?? 0, expense.longitude ?? 0),
                            child: Icon(
                              Icons.location_on,
                              color: colors.primary,
                              size: 50,
                            ))
                      ]),
                    ],
                  ),
                );
              }),
            ),
            Gap(20)
          ],
          FilledButton.tonalIcon(
              icon: Icon(Icons.delete),
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(colors.errorContainer),
                  foregroundColor:
                      WidgetStatePropertyAll(colors.onErrorContainer)),
              onPressed: () => showDeleteExpenseDialog(context),
              label: Text('Delete expense'))
        ],
      ),
    );
  }
}
