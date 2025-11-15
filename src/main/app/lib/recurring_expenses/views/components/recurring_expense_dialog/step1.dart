import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/recurring_expenses/state/add_recurring_expense.dart';

class Step1 extends StatelessWidget {
  final Function setCategory, setName;
  final Category? selected;
  final String name;

  const Step1({super.key, required this.setCategory, this.selected, required this.setName, required this.name});

  onSelect(Category e) {
    setCategory(e);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final cubit = context.read<AddRecurringExpenseCubit>();

        final categories = context.select((AddRecurringExpenseCubit value) => cubit.state.categories);

        return Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: cubit.nameController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: 'A name maybe ?'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 8.0,
                    runSpacing: 4,
                    children: categories
                        .map(
                          (e) => GestureDetector(
                            onTap: () => onSelect(e),
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (selected?.icon ?? '') != e.icon ? Colors.transparent : colors.primaryContainer,
                              ),
                              duration: panelTransition,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: getIcon(
                                  e.icon!,
                                  size: 24,
                                  color: (selected?.icon ?? '') == e.icon ? colors.onPrimaryContainer : colors.primary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
