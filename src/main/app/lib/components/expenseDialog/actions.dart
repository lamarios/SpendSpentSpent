import 'package:after_layout/after_layout.dart';
import 'package:app/globals.dart';
import 'package:app/models/currencyConversion.dart';
import 'package:app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

const CURRENCIES = [
  "AUD",
  "BGN",
  "BRL",
  "CAD",
  "CHF",
  "CNY",
  "CZK",
  "DKK",
  "EUR",
  "GBP",
  "HKD",
  "HRK",
  "HUF",
  "IDR",
  "ILS",
  "INR",
  "ISK",
  "JPY",
  "KRW",
  "MXN",
  "MYR",
  "NOK",
  "NZD",
  "PHP",
  "PLN",
  "RON",
  "RUB",
  "SEK",
  "SGD",
  "THB",
  "TRY",
  "USD",
  "ZAR"
];

class ExpenseActions extends StatefulWidget {
  Function setDate, setNote, setLocation;
  DateTime expenseDate;
  bool location;
  CurrencyConversion? currencyConversion;
  Function? setCurrencyConversion;

  ExpenseActions(
      {required this.setDate,
      required this.expenseDate,
      required this.setNote,
      required this.location,
      required this.setLocation,
      this.currencyConversion,
      this.setCurrencyConversion});

  @override
  ExpenseActionsState createState() => ExpenseActionsState();
}

class ExpenseActionsState extends State<ExpenseActions>
    with AfterLayoutMixin<ExpenseActions> {
  var expenseDate = DateTime.now();
  var showNote = false;
  var location = false;
  var showCurrencyConversion = false;
  var noteController = TextEditingController();
  String fromCurrency = CURRENCIES[0];
  String toCurrency = CURRENCIES[1];

  Future<void> selectDate() async {
    var date = await showDatePicker(
        context: context,
        initialDate: widget.expenseDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    widget.setDate(date ?? widget.expenseDate);
  }

  @override
  void initState() {
    noteController.addListener(() {
      widget.setNote(noteController.text);
    });

    super.initState();
  }

  void changeFromCurrency(String? currency) {
    var newCurrency = currency ?? CURRENCIES[0];
    Preferences.set(Preferences.FROM_CURRENCY, newCurrency);
    setState(() {
      fromCurrency = newCurrency;
      setCurrency();
    });
  }

  void changeToCurrency(String? currency) {
    var newCurrency = currency ?? CURRENCIES[1];
    Preferences.set(Preferences.TO_CURRENCY, newCurrency);
    setState(() {
      toCurrency = newCurrency;
      setCurrency();
    });
  }

  Future<void> setCurrency() async {
      var rate = await service.getCurrencyRate(fromCurrency, toCurrency);
      var currency =
          CurrencyConversion(from: fromCurrency, to: toCurrency, rate: rate);
      widget.setCurrencyConversion!(currency);
  }

  void enableCurrencyConversion() {
    setState(() {
      showNote = false;
      showCurrencyConversion = !showCurrencyConversion;
      setCurrency();
    });
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 4),
                    child: Text(
                        DateFormat('yyyy-MM-dd').format(widget.expenseDate)),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    onPressed: () {
                      widget.setLocation(!widget.location);
                    },
                    icon: FaIcon(FontAwesomeIcons.locationArrow,
                        color: widget.location
                            ? Theme.of(context).accentColor
                            : Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        showNote = !showNote;
                        showCurrencyConversion = false;
                      });
                    },
                    icon: FaIcon(FontAwesomeIcons.solidEdit,
                        color: noteController.text.length > 0
                            ? Theme.of(context).accentColor
                            : Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 0),
                child: IconButton(
                    onPressed: enableCurrencyConversion,
                    icon: FaIcon(FontAwesomeIcons.dollarSign,
                        color: widget.currencyConversion != null
                            ? Theme.of(context).accentColor
                            : Colors.black)),
              ),
              Visibility(
                visible: widget.currencyConversion != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: IconButton(
                      onPressed: () {
                        widget.setCurrencyConversion!(null);
                        setState(() {
                          showCurrencyConversion = false;
                        });
                      },
                      icon: FaIcon(FontAwesomeIcons.times,
                          color: widget.currencyConversion != null
                              ? Theme.of(context).accentColor
                              : Colors.black)),
                ),
              ),
            ],
          ),
        ),
        Visibility(
            visible: showNote,
            child: Container(
              color: Colors.grey[350],
              child: TextField(
                controller: noteController,
                decoration:
                    InputDecoration(hintText: 'Something about this expense'),
              ),
            )),
        Visibility(
            visible: showCurrencyConversion,
            child: Container(
                color: Colors.grey[350],
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Text('From: '),
                          DropdownButton(
                              value: fromCurrency,
                              onChanged: changeFromCurrency,
                              items: CURRENCIES.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList())
                        ],
                      ),
                    )),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Text('To: '),
                          DropdownButton(
                              value: toCurrency,
                              onChanged: changeToCurrency,
                              items: CURRENCIES.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList())
                        ],
                      ),
                    )),
                  ],
                ))),
      ],
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var from = await Preferences.get(Preferences.FROM_CURRENCY, CURRENCIES[0]);
    var to = await Preferences.get(Preferences.TO_CURRENCY, CURRENCIES[1]);

    setState(() {
      fromCurrency = from;
      toCurrency = to;
    });
  }
}
