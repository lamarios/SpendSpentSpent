import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/components/expenseDialog/actions.dart';
import 'package:spend_spent_spent/components/expenseDialog/currencyConverter.dart';
import 'package:spend_spent_spent/components/expenseDialog/keypad.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:spend_spent_spent/models/currencyConversion.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

class AddExpense extends StatefulWidget {
  Category category;

  AddExpense({required this.category});

  @override
  AddExpenseState createState() => AddExpenseState();
}

class AddExpenseState extends State<AddExpense> with AfterLayoutMixin<AddExpense> {
  String value = "";
  String valueFrom = "";
  var expenseDate = DateTime.now();
  var expenseNote = "";
  bool useLocation = false;
  CurrencyConversion? currencyConversion;
  bool showCurrencyConversion = false;
  bool saving = false;

  void addNumber(String i) {
    if (currencyConversion == null) {
      setState(() {
        value = (value + i).replaceFirst(RegExp(r'^0+'), '');
      });
    } else {
      setState(() {
        valueFrom = (valueFrom + i).replaceFirst(RegExp(r'^0+'), '');
        calculateRateConversion();
      });
    }
  }

  void setLocation(location) {
    Preferences.setBool(Preferences.EXPENSE_LOCATION, location);
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

  Future<LocationData> getLocation() async {
    Location location = new Location();
    print(1);
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    print(2);
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print(3);
      _serviceEnabled = await location.requestService();
      print(4);
      if (!_serviceEnabled) {
        throw Exception('Location service not enabled');
      }
    }

    print(5);
    _permissionGranted = await location.hasPermission();
    print(6);
    if (_permissionGranted == PermissionStatus.denied) {
      print(7);
      _permissionGranted = await location.requestPermission();
      print(8);
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Location not allowed');
      }
    }

    print(9);
    try {
      _locationData = await location.getLocation();
      return _locationData;
    } catch (e) {
      print(e);
      throw Exception("Couldn't get data");
    }
    print(10);
  }

  Future<void> addExpense(BuildContext context) async {
    setState(() {
      saving = true;
    });
    print('add expense');
    var amount = double.parse(valueToStr(value));
    var date = DateFormat('yyyy-MM-dd').format(expenseDate);
    var note = expenseNote;
    if (currencyConversion != null) {
      if (note.length > 0) {
        note += "\n";
      }
      note += '${currencyConversion?.from} ${valueToStr(valueFrom)} -> ${currencyConversion?.to}';
    }
    var expense = Expense(amount: amount, category: widget.category, date: date, note: note);

    print('before location');
    //checking location\
    if (useLocation) {
      try {
        print('yooo');
        LocationData locationData = await getLocation();
        print('sup');
        expense.latitude = locationData.latitude;
        expense.longitude = locationData.longitude;
      } catch (e) {
        print(e.toString());
        showAlertDialog(context, 'Error getting Location', e.toString());
        return;
      }
    }
    print('after location');

    await service.addExpense(expense);
    closeDialog();
  }

  void closeDialog() {
    Navigator.pop(context);
  }

  double getIconHeight(MediaQueryData mq) {
    return min(mq.size.height / 5, 150);
  }

  @override
  Widget build(BuildContext context) {
    double iconHeight = getIconHeight(MediaQuery.of(context));

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: defaultBorder),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: iconHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultBorder,
                        color: Colors.grey[350],
                      ),
                      child: Row(
                        children: [
                          Visibility(
                            visible: !showCurrencyConversion,
                            child: Expanded(
                                child: Container(
                                    height: 70,
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(valueToStr(value), style: TextStyle(fontSize: 20)),
                                    ))),
                          ),
                          Visibility(
                            visible: showCurrencyConversion,
                            child: Expanded(
                                child: CurrencyConverter(
                              value: value,
                              valueFrom: valueFrom,
                              currencyConversion: currencyConversion,
                              setCurrencyConversion: setCurrencyConversion,
                              valueToStr: valueToStr,
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                  KeyPad(addNumber: addNumber, removeNumber: removeNumber),
                  ExpenseActions(
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
                    currencyConversionEnabled: showCurrencyConversion,
                    enableCurrencyConversion: (enable) {
                      setState(() {
                        showCurrencyConversion = enable;
                        if (!enable) {
                          currencyConversion = null;
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: TextButton(onPressed: value.length > 0 ? () => addExpense(context) : null, child: Text('Save'), style: flatButtonStyle)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: saving ? 0 : constraints.maxHeight - iconHeight,
              duration: panelTransition,
              curve: Curves.easeInOutQuart,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), //color of shadow
                    spreadRadius: 2, //spread radius
                    blurRadius: 3, // blur radius
                    offset: Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ], gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.5], begin: Alignment.bottomCenter, end: Alignment.topRight), borderRadius: defaultBorder),
                child: Hero(tag: widget.category.icon!, child: DummyFade(running: saving, child: getIcon(widget.category.icon!, size: iconHeight * 0.66))),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: AnimatedOpacity(
                duration: panelTransition,
                opacity: saving ? 0 : 1,
                child: IconButton(
                    onPressed: closeDialog,
                    icon: FaIcon(
                      FontAwesomeIcons.times,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var location = await Preferences.getBool(Preferences.EXPENSE_LOCATION);
    setState(() {
      useLocation = location;
    });
  }
}
