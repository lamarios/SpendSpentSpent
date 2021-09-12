import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/components/categories/categoryGrid.dart';
import 'package:spend_spent_spent/components/dummies/dummyGrid.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  CategoryList() : super();

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList>
    with AfterLayoutMixin<CategoryList> {
  List<Category>? categories;
  Widget grid = DummyGrid();

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
  }

  Future<void> loadCategories() async {
    List<Category> categories = await service.getCategories();
    if (this.mounted) {
      setState(() {
        this.categories = categories;
        this.grid = CategoryGrid(this.categories as List<Category>);
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadCategories();
    FBroadcast.instance().register(BROADCAST_REFRESH_CATEGORIES,
        (context, somethingElse) => loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return grid;
  }
}
