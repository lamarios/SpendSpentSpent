import 'package:app/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCategoryGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: defaultBorder,
          border: Border.all(width: 3, color: Colors.blue[100]!)),
      child: FaIcon(
        FontAwesomeIcons.plus,
        color: Colors.blue[100],
      ),
    );
  }
}
