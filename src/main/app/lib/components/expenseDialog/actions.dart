import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ExpenseActions extends StatefulWidget {
  Function setDate, setNote, setLocation, enableCurrencyConversion;
  DateTime expenseDate;
  bool location;
  bool currencyConversionEnabled;

  ExpenseActions(
      {required this.setDate,
      required this.expenseDate,
      required this.setNote,
      required this.location,
      required this.setLocation,
      required this.enableCurrencyConversion,
      required this.currencyConversionEnabled});

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                  style: flatButtonStyle,
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
                    icon: FaIcon(FontAwesomeIcons.locationArrow, color: widget.location ? Theme.of(context).accentColor : Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    onPressed: () => showNoteDialog(context), icon: FaIcon(FontAwesomeIcons.commentDots, color: noteController.text.length > 0 ? Theme.of(context).accentColor : Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 0),
                child:
                    IconButton(onPressed: enableCurrencyConversion, icon: FaIcon(FontAwesomeIcons.dollarSign, color: widget.currencyConversionEnabled ? Theme.of(context).accentColor : Colors.black)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {}
}
