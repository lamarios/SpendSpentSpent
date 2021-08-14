import 'package:app/components/expenseDialog/actions.dart';
import 'package:app/components/expenseDialog/keypad.dart';
import 'package:app/globals.dart';
import 'package:app/icons.dart';
import 'package:app/models/category.dart';
import 'package:app/models/currencyConversion.dart';
import 'package:app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  Category category;

  AddExpense({required this.category});

  @override
  AddExpenseState createState() => AddExpenseState();
}

class AddExpenseState extends State<AddExpense> {
  String value = "";
  String valueFrom = "";
  var expenseDate = DateTime.now();
  var expenseNote = "";
  bool useLocation = false;
  CurrencyConversion? currencyConversion;

  void addNumber(String i) {
    if (currencyConversion == null) {
      setState(() {
        value += i;
      });
    } else {
      setState(() {
        valueFrom += i;
        calculateRateConversion();
      });
    }
  }

  void setLocation(location) {
    setState(() {
      this.useLocation = location;
    });
  }

  void removeNumber() {
    if (value.length > 0) {
      setState(() {
        value = value.substring(0, value.length - 1);
      });
    }
    if (valueFrom.length > 0) {
      setState(() {
        valueFrom = valueFrom.substring(0, valueFrom.length - 1);
      });
    }
  }

  void calculateRateConversion() {
    var from = valueFrom.length > 0 ? valueFrom : "0";
    double rate = currencyConversion?.rate ?? 1;
    double fromDouble = double.parse(from);
    var newToValue = fromDouble * rate;
    setState(() {
      value = newToValue.floor().toString();
    });
  }

  void setCurrencyConversion(CurrencyConversion currencyConversion) {
    setState(() {
      this.currencyConversion = currencyConversion;
      calculateRateConversion();
    });
  }

  String valueToStr(from) {
    String str = from.padLeft(3, '0');
    List<String> split = str.split('');
    split.insert(split.length - 2, '.');

    str = split.join('');

    return str;
  }

  Future<void> addExpense() async {
    var amount = double.parse(valueToStr(value));
    var date = DateFormat('yyyy-MM-dd').format(expenseDate);
    var note = expenseNote;
    if (currencyConversion != null) {
      if (note.length > 0) {
        note += "\n";
      }
      note += '${currencyConversion?.from} ${valueToStr(valueFrom)} -> ${currencyConversion?.to}';
    }
    var expense = Expense(
        amount: amount, category: widget.category, date: date, note: note);

    await service.addExpense(expense);
    closeDialog();
  }

  void closeDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.blue],
                        stops: [0, 0.5],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topRight)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Hero(
                      tag: widget.category.icon!,
                      child: getIcon(widget.category.icon!, size: 100)),
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: currencyConversion == null,
                    child: Expanded(
                        child: Container(
                            height: 70,
                            color: Colors.grey[350],
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(valueToStr(value),
                                  style: TextStyle(fontSize: 20)),
                            ))),
                  ),
                  Visibility(
                    visible: currencyConversion != null,
                    child: Expanded(
                        child: Container(
                            height: 70,
                            color: Colors.grey[350],
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                        '${currencyConversion?.from}  ${valueToStr(valueFrom)}',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                        '${currencyConversion?.to}  ${valueToStr(value)}',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                ],
                              ),
                            ))),
                  )
                ],
              ),
              KeyPad(addNumber: addNumber, removeNumber: removeNumber),
              Expanded(
                child: ExpenseActions(
                  expenseDate: expenseDate,
                  setDate: (date) {
                    setState(() {
                      expenseDate = date;
                    });
                  },
                  setNote: (note) {
                    setState(() {
                      expenseNote = note;
                    });
                  },
                  location: useLocation,
                  setLocation: setLocation,
                  currencyConversion: currencyConversion,
                  setCurrencyConversion: setCurrencyConversion,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: addExpense,
                            child: Text('Save'),
                            style: flatButtonStyle)),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
                onPressed: closeDialog,
                icon: FaIcon(
                  FontAwesomeIcons.times,
                  color: Colors.white,
                  size: 20,
                )),
          ),
        ],
      ),
    );
  }
}
