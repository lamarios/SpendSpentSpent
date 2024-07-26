import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/components/dummies/dummySearchCategories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/searchParameters.dart';

import '../../utils/debouncer.dart';

class Search extends StatefulWidget {
  final Function search;

  const Search({super.key, required this.search});

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> with AfterLayoutMixin {
  double iconWidth = 30;
  SearchParameters searchParametersBounds = SearchParameters(
          categories: [], maxAmount: 0, minAmount: 0, note: ""),
      searchParameters = SearchParameters(
          categories: [], maxAmount: 0, minAmount: 0, note: "");
  TextEditingController noteController = TextEditingController();
  Debouncer debouncer = Debouncer(milliseconds: 1000);

  getSearchParameters() {
    int? categoryId;
    if (searchParameters.categories.isNotEmpty) {
      categoryId = searchParameters.categories[0].id;
    }

    service.getSearchParameters(categoryId).then((value) {
      setState(() {
        searchParameters = SearchParameters(
            categories: searchParameters.categories,
            maxAmount: value.maxAmount,
            minAmount: value.minAmount,
            note: searchParameters.note);
        searchParametersBounds = SearchParameters(
            categories: value.categories,
            maxAmount: value.maxAmount,
            minAmount: value.minAmount,
            note: "");
      });
    });
  }

  updateRange(RangeValues range) {
    SearchParameters params = searchParameters;
    params.minAmount = range.start.floor();
    params.maxAmount = range.end.ceil();

    setState(() {
      searchParameters = params;
      debouncer.run(() => widget.search(searchParameters));
    });
  }

  selectCategory(Category c) {
    SearchParameters params = searchParameters;
    if (c.id == null) {
      params.categories = [];
    }

    if (params.categories.isNotEmpty && params.categories[0].id == c.id) {
      params.categories = [];
    } else {
      params.categories = [c];
    }
    print('selected category ${c.id}');
    setState(() {
      searchParameters = params;
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
    final colors = Theme.of(context).colorScheme;
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedCrossFade(
                  duration: panelTransition,
                  crossFadeState: searchParametersBounds.categories.isEmpty
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: DummySearchCategories(),
                  secondChild: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: searchParametersBounds.categories.map((c) {
                      var isSelected =
                          searchParameters.categories.length == 1 &&
                              searchParameters.categories[0].id == c.id;
                      return GestureDetector(
                        onTap: () => selectCategory(c),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                                color: isSelected
                                    ? colors.primary
                                    : colors.surface),
                            duration: panelTransition,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: getIcon(c.icon ?? "",
                                  color: isSelected
                                      ? colors.onPrimaryContainer
                                      : colors.primary,
                                  size: 20),
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
            Container(
                width: iconWidth,
                child:
                    FaIcon(FontAwesomeIcons.dollarSign, color: colors.primary)),
            Expanded(
              child: RangeSlider(
                values: RangeValues(searchParameters.minAmount.toDouble(),
                    searchParameters.maxAmount.toDouble()),
                onChanged: updateRange,
                divisions: searchParametersBounds.maxAmount > 0
                    ? searchParametersBounds.maxAmount -
                        searchParametersBounds.minAmount
                    : null,
                max: searchParametersBounds.maxAmount.toDouble(),
                min: searchParametersBounds.minAmount.toDouble(),
                labels: RangeLabels(searchParameters.minAmount.toString(),
                    searchParameters.maxAmount.toString()),
              ),
            ),
          ]),
          Row(
            children: [
              SizedBox(
                  width: iconWidth,
                  child: FaIcon(FontAwesomeIcons.commentDots,
                      color: colors.primary)),
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
    getSearchParameters();
  }
}
