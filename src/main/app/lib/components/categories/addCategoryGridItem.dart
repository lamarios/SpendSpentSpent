import 'package:animations/animations.dart';
import 'package:app/globals.dart';
import 'package:app/utils/dialogs.dart';
import 'package:app/views/addCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCategoryGridItem extends StatelessWidget {

  void showAddCategory(BuildContext context){
    showModal(
        context: context,
        builder: (context) => Card(
            margin: getInsetsForMaxSize(MediaQuery.of(context), 600),
            child: AddCategory()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAddCategory(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: defaultBorder,
            border: Border.all(width: 3, color: Colors.blue[100]!)),
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.blue[100],
        ),
      ),
    );
  }
}