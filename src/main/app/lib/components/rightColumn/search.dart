import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/components/dummies/dummySearchCategories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:spend_spent_spent/models/searchParameters.dart';

import '../../utils/colorUtils.dart';
import '../../utils/debouncer.dart';
import '../../views/login.dart';

class Search extends StatefulWidget {
  Function search;

  Search({required this.search});

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> with AfterLayoutMixin {
  double iconWidth = 30;
  SearchParameters searchParametersBounds = SearchParameters(categories: [], maxAmount: 0, minAmount: 0, note: ""),
      searchParameters = SearchParameters(categories: [], maxAmount: 0, minAmount: 0, note: "");
  TextEditingController noteController = TextEditingController();
  Debouncer debouncer = Debouncer(milliseconds: 1000);

  getSearchParameters() {
    int? categoryId;
    if (this.searchParameters.categories.length > 0) {
      categoryId = this.searchParameters.categories[0].id;
    }

    service.getSearchParameters(categoryId).then((value) {
      setState(() {
        this.searchParameters = SearchParameters(categories: searchParameters.categories, maxAmount: value.maxAmount, minAmount: value.minAmount, note: searchParameters.note);
        this.searchParametersBounds = SearchParameters(categories: value.categories, maxAmount: value.maxAmount, minAmount: value.minAmount, note: "");
      });
    });
  }

  updateRange(RangeValues range) {
    SearchParameters params = this.searchParameters;
    params.minAmount = range.start.floor();
    params.maxAmount = range.end.ceil();

    setState(() {
      this.searchParameters = params;
      debouncer.run(() => widget.search(searchParameters));
    });
  }

  selectCategory(Category c) {
    SearchParameters params = this.searchParameters;
    if (c.id == null) {
      params.categories = [];
    }

    if (params.categories.length > 0 && params.categories[0].id == c.id) {
      params.categories = [];
    } else {
      params.categories = [c];
    }
    print('selected category ${c.id}');
    setState(() {
      this.searchParameters = params;
      debouncer.run(() => widget.search(searchParameters));
      getSearchParameters();
    });
  }

  setNote() {
    SearchParameters params = searchParameters;
    params.note = noteController.text;
    setState(() {
      searchParameters = params;
      debouncer.run(() => widget.search(searchParameters));
    });
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedCrossFade(
                  duration: panelTransition,
                  crossFadeState: searchParametersBounds.categories.length == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: DummySearchCategories(),
                  secondChild: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: searchParametersBounds.categories.map((c) {
                      var isSelected = searchParameters.categories.length == 1 && searchParameters.categories[0].id == c.id;
                      return GestureDetector(
                        onTap: () => selectCategory(c),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: isSelected ? colors.main : colors.background),
                            duration: panelTransition,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: getIcon(c.icon ?? "", color: isSelected ? colors.textOnMain : colors.main, size: 20),
                            ),
                          ),
                        ),
                      );
                    }).toList()),
                  ),
                ),
              )
            ],
          ),
          Row(children: [
            Container(width: iconWidth, child: FaIcon(FontAwesomeIcons.dollarSign, color: colors.main)),
            Expanded(
              child: RangeSlider(
                values: RangeValues(this.searchParameters.minAmount.toDouble(), this.searchParameters.maxAmount.toDouble()),
                onChanged: updateRange,
                divisions: this.searchParametersBounds.maxAmount > 0 ? this.searchParametersBounds.maxAmount - this.searchParametersBounds.minAmount : null,
                max: this.searchParametersBounds.maxAmount.toDouble(),
                min: this.searchParametersBounds.minAmount.toDouble(),
                labels: RangeLabels(this.searchParameters.minAmount.toString(), this.searchParameters.maxAmount.toString()),
              ),
            ),
          ]),
          Row(
            children: [
              Container(width: iconWidth, child: FaIcon(FontAwesomeIcons.commentDots, color: colors.main)),
              Expanded(
                  child: PlatformTextField(
                controller: noteController,
                autocorrect: false,
                hintText: "Expense note",
              ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    noteController.addListener(setNote);
    this.getSearchParameters();
  }
}
