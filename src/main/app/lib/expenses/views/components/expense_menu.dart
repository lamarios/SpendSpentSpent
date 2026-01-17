import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/expenses/state/expense_menu.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/expenses/views/components/expense_images.dart';
import 'package:spend_spent_spent/expenses/views/components/stylized_amount.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/users/views/components/user_profile_icon.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

import '../../models/expense.dart';

class ExpenseMenu extends StatelessWidget {
  final Expense expense;

  const ExpenseMenu({super.key, required this.expense});

  static Future<void> showSheet(BuildContext context, Expense expense) async {
    var colors = context.read<HouseholdCubit>().state.getCategoryColor(context, expense.category);

    await showMotorBottomSheet(
      context: context,
      // context: context,
      // isScrollControlled: true,
      // showDragHandle: true,
      // useSafeArea: true,
      // builder: (context) {
      child: Theme(
        data: Theme.of(context).copyWith(colorScheme: colors),
        child: Container(
          color: colors.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Wrap(children: [ExpenseMenu(expense: expense)]),
          ),
        ),
      ),
    );
  }

  Future<void> editExpense(BuildContext context, Expense expense) async {
    final exp = await AddExpense.showDialog(context, expense: expense);
    if (exp != null && context.mounted) {
      context.read<ExpenseMenuCubit>().setExpense(exp);
    }
  }

  void showDeleteExpenseDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Expense ?'),
        content: const Text('This will only delete this expense, it is not recoverable.'),
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

  Future<void> deleteExpense(BuildContext context) async {
    await service.deleteExpense(expense.id!);
    if (context.mounted) {
      context.read<LastExpenseCubit>().refresh();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseColors = context.read<HouseholdCubit>().state.getCategoryColor(context, expense.category);

    return BlocProvider(
      create: (context) => ExpenseMenuCubit(ExpenseMenuState(expense: expense)),
      child: BlocBuilder<ExpenseMenuCubit, ExpenseMenuState>(
        builder: (context, state) {
          final expense = state.expense;

          bool hasMap = state.expense.hasLocation;
          final colors = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          final screenSize = MediaQuery.sizeOf(context);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    getIcon(expense.category.icon!, size: 32, color: colors.onSurface),
                    StylizedAmount(amount: expense.amount, size: 40),
                  ],
                ),
                if (expense.note != null && expense.note!.trim().isNotEmpty)
                  Row(
                    spacing: 16,
                    children: [
                      Icon(Icons.comment, color: colors.secondary),
                      Expanded(child: Text(expense.note!, style: textTheme.bodyLarge)),
                    ],
                  ),
                if (!state.isOwnExpense)
                  Row(
                    spacing: 16,
                    children: [
                      UserProfileIcon(user: expense.category.user!, size: 40, colorScheme: expenseColors),
                      Text('${expense.category.user?.firstName} ${expense.category.user?.lastName}'),
                    ],
                  ),
                if (hasMap || expense.files.isNotEmpty)
                  SizedBox(
                    height: screenSize.height * 0.6,
                    child: Column(
                      spacing: 16,
                      children: [
                        if (hasMap) ...[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(bigItemBorderRadius),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return FlutterMap(
                                    options: MapOptions(
                                      initialZoom: 15,
                                      initialCenter: LatLng((expense.latitude ?? 0), expense.longitude ?? 0),
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                        userAgentPackageName: 'com.spendspentspent.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            width: 40.0,
                                            height: 40.0,
                                            point: LatLng(expense.latitude ?? 0, expense.longitude ?? 0),
                                            child: Icon(Icons.location_on, color: colors.primaryContainer, size: 50),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                        if (expense.files.isNotEmpty)
                          Expanded(
                            child: ExpenseImages(key: ValueKey(expense.files), initialFiles: expense.files),
                          ),
                      ],
                    ),
                  ),
                if (state.isOwnExpense)
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          icon: Icon(Icons.edit),
                          onPressed: state.loading ? null : () => editExpense(context, expense),
                          label: Text('Edit expense'),
                        ),
                      ),
                      IconButton.filledTonal(
                        icon: Icon(Icons.delete),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(colors.errorContainer),
                          foregroundColor: WidgetStatePropertyAll(colors.onErrorContainer),
                        ),
                        onPressed: () => showDeleteExpenseDialog(context),
                      ),
                    ],
                  ),
                if (kIsWeb) Gap(16),
              ],
            ),
          );
        },
      ),
    );
  }
}
