import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Step1 extends StatefulWidget {
  Function setCategory;
  Category? selected;

  Step1({required this.setCategory, this.selected});

  @override
  Step1State createState() => Step1State();
}

class Step1State extends State<Step1> with AfterLayoutMixin {
  List<Category> categories = [];

  getCategories() {
    service.getCategories().then((value) {
      setState(() {
        categories = value;
      });
    });
  }

  onSelect(Category e) {
    print('selecting ');
    widget.setCategory(e);
  }

  @override
  Widget build(BuildContext context) {

    print('selected ${widget.selected}');
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4,
          children: categories
              .map((e) => GestureDetector(
                    onTap: () => onSelect(e),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: defaultBorder,
                        color: (widget.selected?.icon ?? '') != e.icon ? Colors.white : Theme.of(context).primaryColor,
                      ),
                      duration: panelTransition,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getIcon(e.icon!, size: 30, color: (widget.selected?.icon ?? '') == e.icon ? Colors.white : Theme.of(context).primaryColor),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print('getting cats');
    getCategories();
  }
}
