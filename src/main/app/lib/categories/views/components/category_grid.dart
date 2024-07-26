import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/views/components/add_category_grid_item.dart';
import 'package:spend_spent_spent/categories/views/components/category_grid_item.dart';
import 'package:spend_spent_spent/categories/views/components/settings_category_item.dart';
import 'package:spend_spent_spent/globals.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoryGrid(this.categories);

  @override
  Widget build(BuildContext context) {
    int columns = columnCount(MediaQuery.of(context));

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: categories.length + 2,
        padding: const EdgeInsets.only(top: 20),
        itemBuilder: (BuildContext context, int index) {
          if (index == categories.length + 1) {
            return SettingsCategoryGridItem();
          } else if (index == categories.length) {
            return AddCategoryGridItem();
          } else {
            Category cat = categories[index];
            return CategoryGridItem(category: cat);
          }
        });
  }
}
