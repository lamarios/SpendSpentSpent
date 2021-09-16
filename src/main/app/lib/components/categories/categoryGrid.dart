import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spend_spent_spent/components/categories/addCategoryGridItem.dart';
import 'package:spend_spent_spent/components/categories/categoryGridItem.dart';
import 'package:spend_spent_spent/components/categories/settingsCategoryItem.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/category.dart';

class CategoryGrid extends StatefulWidget {
  List<Category> categories;

  CategoryGrid(this.categories);

  @override
  CategoryGridState createState() => CategoryGridState();
}


class CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    int columns = columnCount(MediaQuery.of(context));

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: widget.categories.length + 2,
        padding: const EdgeInsets.only(top: 20),
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.categories.length + 1) {
            return SettingsCategoryGridItem();
          } else if (index == widget.categories.length) {
            return AddCategoryGridItem();
          } else {
            Category cat = widget.categories[index];
            return CategoryGridItem(category: cat);
          }
        });
  }
}
