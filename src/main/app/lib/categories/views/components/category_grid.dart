import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
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
    final textTheme = Theme.of(context).textTheme;

    int columns = columnCount(MediaQuery.of(context));

    return categories.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.sentiment_neutral, size: 100),
              Gap(24),
              Text(
                'No expense categories yet, add one !',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
              Gap(24),
              FilledButton.tonalIcon(
                onPressed: () => AddCategoryGridItem.showAddCategory(context),
                label: Text('Add Category'),
                icon: Icon(Icons.add),
              ),
            ],
          )
        : SingleChildScrollView(
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
