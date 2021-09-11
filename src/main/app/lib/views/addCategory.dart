import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/components/addCategoryDialog/categories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/availableCategories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCategory extends StatefulWidget {
  Function onSelected;
  String? buttonLabel;

  AddCategory({required this.onSelected, this.buttonLabel});

  @override
  AddCategoryState createState() => AddCategoryState();
}

class AddCategoryState extends State<AddCategory> with AfterLayoutMixin<AddCategory> {
  AvailableCategories categories = AvailableCategories();
  String selected = '';

  Timer? debounce;
  final searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    searchController.addListener(search);
  }

  void search() {
    print('searching');
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      service.searchAvailableCategories(searchController.text).then((value) {
        setState(() {
          selected = '';
          categories = value;
        });
      });
    });
  }

  void onSelect(String s) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      this.selected = s;
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  addCategory(BuildContext context) async {
    widget.onSelected(selected);
    Navigator.pop(context);
  }

  closeDialog(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Theme.of(context).primaryColorDark,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.search,
                        color: Colors.black.withOpacity(0.2),
                        size: 15,
                      ),
                    ),
                    Expanded(
                      child: PlatformTextField(
                        controller: searchController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'Search',
                        material: (_, __) => MaterialTextFieldData(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)))),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Categories(
                        label: 'Shopping',
                        categories: categories.shopping,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Transports',
                        categories: categories.transports,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Brands',
                        categories: categories.brands,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Hobbies',
                        categories: categories.hobbies,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Health',
                        categories: categories.health,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Education',
                        categories: categories.education,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Housing',
                        categories: categories.housing,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Tech',
                        categories: categories.tech,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                      Categories(
                        label: 'Documents',
                        categories: categories.documents,
                        onSelect: onSelect,
                        selected: selected,
                      ),
                    ],
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child:
                            TextButton(onPressed: selected != '' ? () => addCategory(context) : null, child: Text(widget.buttonLabel ?? 'Add category'), style: flatButtonStyle)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 3,
          child: IconButton(
              onPressed: () => closeDialog(context),
              icon: FaIcon(
                FontAwesomeIcons.times,
                color: Colors.white,
                size: 20,
              )),
        ),
      ],
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    AvailableCategories categories = await service.getAvailableCategories();
    setState(() {
      print('YOLO $categories');
      this.categories = categories;
    });
  }
}
