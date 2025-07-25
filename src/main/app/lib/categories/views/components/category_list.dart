import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/categories/views/components/category_grid.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/dummyGrid.dart';

@RoutePage()
class CategoryListTab extends StatelessWidget {
  const CategoryListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
      return Align(
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
            duration: panelTransition,
            child: state.loading
                ? const DummyGrid()
                : CategoryGrid(state.categories)),
      );
    });
  }
}
