import 'package:after_layout/after_layout.dart';
import 'package:app/components/expenseDialog/actions.dart';
import 'package:app/components/expenseDialog/currencyConverter.dart';
import 'package:app/components/expenseDialog/keypad.dart';
import 'package:app/globals.dart';
import 'package:app/icons.dart';
import 'package:app/models/category.dart';
import 'package:app/models/currencyConversion.dart';
import 'package:app/models/expense.dart';
import 'package:app/utils/dialogs.dart';
import 'package:app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AddExpense extends StatefulWidget {
  Category category;

  AddExpense({required this.category});

  @override
  AddExpenseState createState() => AddExpenseState();
}

class AddExpenseState extends State<AddExpense>
    with AfterLayoutMixin<AddExpense> {
  String value = "";
  String valueFrom = "";
  var expenseDate = DateTime.now();
  var expenseNote = "";
  bool useLocation = false;
  CurrencyConversion? currencyConversion;
  bool showCurrencyConversion = false;

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

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception('Location service not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Location not allowed');
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  Future<void> addExpense(BuildContext context) async {
    var amount = double.parse(valueToStr(value));
    var date = DateFormat('yyyy-MM-dd').format(expenseDate);
    var note = expenseNote;
    if (currencyConversion != null) {
      if (note.length > 0) {
        note += "\n";
      }
      note +=
          '${currencyConversion?.from} ${valueToStr(valueFrom)} -> ${currencyConversion?.to}';
    }
    var expense = Expense(
        amount: amount, category: widget.category, date: date, note: note);

    //checking location\
    if (useLocation) {
      try {
        LocationData locationData = await getLocation();
        expense.latitude = locationData.latitude;
        expense.longitude = locationData.longitude;
      } catch (e) {
        print(e.toString());
        showAlertDialog(context, 'Error getting Location', e.toString());
        return;
      }
    }

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
                    visible: !showCurrencyConversion,
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: value.length > 0
                                ? () => addExpense(context)
                                : null,
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

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var location = await Preferences.getBool(Preferences.EXPENSE_LOCATION);
    setState(() {
      useLocation = location;
    });
  }
}
