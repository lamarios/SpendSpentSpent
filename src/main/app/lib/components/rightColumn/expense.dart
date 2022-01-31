import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

const double MAP_HEIGHT = 200;
const double NOTE_HEIGHT = 30;

class OneExpense extends StatefulWidget {
  Expense expense;
  Function showExpense;
  Key? key;

  OneExpense({this.key, required this.showExpense, required this.expense});

  @override
  OneExpenseState createState() => OneExpenseState();
}

class OneExpenseState extends State<OneExpense> with AfterLayoutMixin {
  Offset offset = Offset(-3, 0);
  double opacity = 0;

  openContainer() {
    widget.showExpense(widget.expense);
  }

  bool hasNote() {
    return (widget.expense.note?.length ?? 0) > 0;
  }

  bool hasLocation() {
    return widget.expense.longitude != 0 && widget.expense.latitude != 0;
  }

  @override
  Widget build(BuildContext context) {
    bool hasExtra = hasLocation() || hasNote() || widget.expense.type == 2;

    AppColors colors = get(context);
    return GestureDetector(
      onTap: openContainer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: colors.mainDark),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      getIcon(widget.expense.category.icon!, size: 20, color: colors.iconOnMain),
                      Padding(
                        padding: EdgeInsets.only(right: hasExtra ? 24 : 16),
                        child: Text(
                          formatCurrency(widget.expense.amount),
                          style: TextStyle(color: colors.textOnMain),
                        ),
                      ),
                      Visibility(
                          visible: hasLocation(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AnimatedOpacity(
                              duration: panelTransition,
                              opacity: opacity,
                              child: AnimatedSlide(
                                duration: panelTransition,
                                curve: Curves.easeInOutQuart,
                                offset: offset,
                                child: FaIcon(
                                  FontAwesomeIcons.locationArrow,
                                  color: colors.textOnDarkMain,
                                  size: 15,
                                ),
                              ),
                            ),
                          )),
                      Visibility(
                          visible: hasNote(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AnimatedOpacity(
                              opacity: opacity,
                              duration: panelTransition,
                              child: AnimatedSlide(
                                duration: panelTransition,
                                curve: Curves.easeInOutQuart,
                                offset: offset,
                                child: FaIcon(
                                  FontAwesomeIcons.commentDots,
                                  color: colors.textOnDarkMain,
                                  size: 15,
                                ),
                              ),
                            ),
                          )),
                      Visibility(
                          visible: widget.expense.type == 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AnimatedOpacity(
                              duration: panelTransition,
                              opacity: opacity,
                              child: AnimatedSlide(
                                duration: panelTransition,
                                curve: Curves.easeInOutQuart,
                                offset: offset,
                                child: FaIcon(
                                  FontAwesomeIcons.redo,
                                  color: colors.textOnDarkMain,
                                  size: 15,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: defaultGradient(context),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        getIcon(widget.expense.category.icon!, size: 20, color: colors.iconOnMain),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            formatCurrency(widget.expense.amount),
                            style: TextStyle(color: colors.textOnMain),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Random rand = Random();
    Future.delayed(Duration(milliseconds: rand.nextInt(250)), () {
      setState(() {
        offset += const Offset(3, 0);
        opacity = 1;
      });
    });
  }
}
