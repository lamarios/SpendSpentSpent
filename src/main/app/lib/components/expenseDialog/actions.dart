import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class ExpenseActions extends StatefulWidget {
  Function setDate, setNote, setLocation, enableCurrencyConversion;
  DateTime expenseDate;
  bool location;
  bool currencyConversionEnabled;
  Map<String, int> noteSuggestions;

  ExpenseActions(
      {required this.setDate,
      required this.expenseDate,
      required this.setNote,
      required this.location,
      required this.setLocation,
      required this.enableCurrencyConversion,
      required this.currencyConversionEnabled,
      required this.noteSuggestions});

  @override
  ExpenseActionsState createState() => ExpenseActionsState();
}

class ExpenseActionsState extends State<ExpenseActions> with AfterLayoutMixin<ExpenseActions> {
  var expenseDate = DateTime.now();
  var location = false;
  var showCurrencyConversion = false;
  var noteController = TextEditingController();

  Future<void> selectDate() async {
    var date = await showDatePicker(context: context, initialDate: widget.expenseDate, firstDate: DateTime(1900), lastDate: DateTime(2100));

    widget.setDate(date ?? widget.expenseDate);
  }

  @override
  void initState() {
    noteController.addListener(() {
      widget.setNote(noteController.text);
    });

    super.initState();
  }

  void enableCurrencyConversion() {
    setState(() {
      showCurrencyConversion = !showCurrencyConversion;
      widget.enableCurrencyConversion(!widget.currencyConversionEnabled);
    });
  }

  void showNoteDialog(BuildContext context) {
    showPromptDialog(context, 'Expense note', "Something about this expense", noteController, () {});
  }

  void tapSuggestion(String text) {
    widget.setNote(text);
    noteController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    // TODO: implement build
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
          child: Row(
            children: [
              TextButton(
                  // style: flatButtonStyle,
                  onPressed: selectDate,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
                    child: Text(DateFormat('yyyy-MM-dd').format(widget.expenseDate)),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    onPressed: () {
                      widget.setLocation(!widget.location);
                    },
                    icon: FaIcon(FontAwesomeIcons.locationArrow, color: widget.location ? colors.main : colors.text)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      color: widget.noteSuggestions.isEmpty ? colors.background : colors.expenseInputBackground,
                    ),
                    duration: Duration(milliseconds: panelTransition.inMilliseconds ~/ 2),
                    child: IconButton(onPressed: () => showNoteDialog(context), icon: FaIcon(FontAwesomeIcons.commentDots, color: noteController.text.length > 0 ? colors.main : colors.text))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 0),
                child: IconButton(onPressed: enableCurrencyConversion, icon: FaIcon(FontAwesomeIcons.dollarSign, color: widget.currencyConversionEnabled ? colors.main : colors.text)),
              ),
            ],
          ),
        ),
        AnimatedOpacity(
            opacity: widget.noteSuggestions.isNotEmpty ? 1 : 0,
            duration: panelTransition ~/ 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: defaultBorder,
                  color: colors.expenseInputBackground,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Wrap(
                        children: widget.noteSuggestions.keys
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () => tapSuggestion(e),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: defaultBorder,
                                          color: colors.main,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            e,
                                            style: TextStyle(color: colors.textOnMain),
                                          ),
                                        )),
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {}
}
