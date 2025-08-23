import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/views/components/add_category_grid_item.dart';
import 'package:spend_spent_spent/categories/views/components/category_grid_item.dart';
import 'package:spend_spent_spent/categories/views/components/settings_category_item.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoryGrid(this.categories, {super.key});

  @override
  Widget build(BuildContext context) {
    int columns = columnCount(MediaQuery.of(context));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: bottomPadding),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length + 2,
          padding: const EdgeInsets.only(top: 20),
          itemBuilder: (BuildContext context, int index) {
            if (index == categories.length + 1) {
              return const SettingsCategoryGridItem();
            } else if (index == categories.length) {
              return const AddCategoryGridItem();
            } else {
              Category cat = categories[index];
              return CategoryGridItem(category: cat);
            }
          },
        ),
      ),
    );
  }
}
