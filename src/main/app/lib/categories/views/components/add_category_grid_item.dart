import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/categories/views/components/add_category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class AddCategoryGridItem extends StatelessWidget {
  const AddCategoryGridItem({super.key});

  static void showAddCategory(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();
    showModal(
      context: context,
      builder: (ctx) => Card(
        margin: getInsetsForMaxSize(
          MediaQuery.of(ctx),
          maxWidth: 350,
          maxHeight: 500,
        ),
        child: AddCategory(
          onSelected: (selected) => cubit.addCategory(selected),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => showAddCategory(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: defaultBorder,
          border: Border.all(
            width: 3,
            color: colors.primary.withValues(alpha: 0.5),
          ),
        ),
        child: Icon(Icons.add, color: colors.primary.withValues(alpha: 0.5)),
      ),
    );
  }
}
