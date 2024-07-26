import 'package:after_layout/after_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/categories/views/components/category_grid.dart';
import 'package:spend_spent_spent/components/dummies/dummyGrid.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:fbroadcast_nullsafety/fbroadcast_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
      return AnimatedSwitcher(
          duration: panelTransition,
          child: state.categories.isEmpty
              ? DummyGrid()
              : CategoryGrid(state.categories));
    });
  }
}
