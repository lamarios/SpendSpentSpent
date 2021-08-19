import 'package:app/components/categories/addCategoryGridItem.dart';
import 'package:app/components/categories/categoryGridItem.dart';
import 'package:app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryGrid extends StatefulWidget {
  List<Category> categories;

  CategoryGrid(this.categories);

  @override
  CategoryGridState createState() => CategoryGridState();
}

class CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: widget.categories.length + 1,
        padding: const EdgeInsets.only(top: 20),
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.categories.length) {
            return AddCategoryGridItem();
          } else {
            Category cat = widget.categories[index];
            return CategoryGridItem(category: cat);
          }
        });
  }
}
