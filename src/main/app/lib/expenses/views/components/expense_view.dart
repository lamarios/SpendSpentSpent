import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/utils/views/components/repeated_icons.dart';

class ExpenseView extends StatelessWidget {
  final Expense expense;

  const ExpenseView(this.expense, {super.key});

  bool hasLocation() {
    return expense.longitude != 0 && expense.latitude != 0;
  }

  bool hasNote() {
    return (expense.note?.length ?? 0) > 0;
  }

  showDeleteExpenseDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Expense ?'),
        content: const Text(
          'This will only delete this expense, it is not recoverable.',
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: TextStyle(color: colors.secondary)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              deleteExpense(context);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  deleteExpense(BuildContext context) async {
    await service.deleteExpense(expense.id!);
    context.read<LastExpenseCubit>().refresh();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    print('${expense.latitude} ${expense.longitude}');
    return Stack(
      children: [
        if (!hasLocation())
          RepeatedIconsBackground(
            icon: expense.category.icon!,
            color: colors.onSurface.withValues(alpha: 0.05),
            size: 40,
            child: const SizedBox.shrink(),
          ),
        if (hasLocation())
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.white,
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialZoom: 15,
                  initialCenter: LatLng(
                    (expense.latitude ?? 0) - 0.013,
                    expense.longitude ?? 0,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.spendspentspent.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: LatLng(
                          expense.latitude ?? 0,
                          expense.longitude ?? 0,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: colors.primary,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: SafeArea(
            bottom: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => showDeleteExpenseDialog(context),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: SafeArea(
            top: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hasLocation()
                          ? colors.surfaceContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.clear,
                        color: colors.onSurface,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 70,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: colors.primaryContainer,
                ),
                width: 100,
                alignment: Alignment.center,
                height: 100,
                child: getIcon(
                  expense.category.icon!,
                  color: colors.onPrimaryContainer,
                  size: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: defaultBorder,
                    color: hasLocation()
                        ? colors.surfaceContainer
                        : Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10,
                    ),
                    child: Text(
                      formatCurrency(expense.amount),
                      style: TextStyle(
                        fontSize: 50,
                        color: colors.onSurface,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: hasNote(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: defaultBorder,
                      color: colors.tertiaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10,
                      ),
                      child: Text(
                        expense.note ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          color: colors.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
