import 'package:after_layout/after_layout.dart';
import 'package:app/components/categories/categoryGrid.dart';
import 'package:app/components/dummies/dummyGrid.dart';
import 'package:app/globals.dart';
import 'package:app/models/category.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiddleColumn extends StatefulWidget {
  MiddleColumn() : super();

  @override
  _MiddleColumnState createState() => _MiddleColumnState();
}

class _MiddleColumnState extends State<MiddleColumn>
    with AfterLayoutMixin<MiddleColumn> {
  List<Category>? categories;

  @override
  void initState() {
    super.initState();
    FBroadcast.instance().register(BROADCAST_LOGGED_IN, (value, callback) {
      loadCategories();
    });
  }

  Future<void> loadCategories() async {
    List<Category> categories = await service.getCategories();
    setState(() {
      this.categories = categories;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return categories == null
        ? DummyGrid()
        : CategoryGrid(categories as List<Category>);
  }
}
