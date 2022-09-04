import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/components/expenseDialog/actions.dart';
import 'package:spend_spent_spent/components/expenseDialog/currencyConverter.dart';
import 'package:spend_spent_spent/components/expenseDialog/keypad.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:spend_spent_spent/models/currencyConversion.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/debouncer.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

const LOCATION_TIMEOUT = 7;

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
  Widget? savingIcon;
  List<String> noteSuggestions = [];
  Debouncer debouncer = Debouncer(milliseconds: 500);

  void getNoteSuggestions(String value) {
    debouncer.run(() {
      service.getNoteSuggestions(Expense(amount: double.parse(valueToStr(value)), date: '2022-01-23', category: widget.category)).then((suggestions) {
        List<String> results = suggestions.keys.toList(growable: false);
        results.sort((a, b) => suggestions[b]!.compareTo(suggestions[a]!));

        setState(() {
          noteSuggestions = results;
          print(noteSuggestions);
        });
      });
    });
  }

  void addNumber(String i) {
    if (currencyConversion == null) {
      String tempValue = (value + i).replaceFirst(RegExp(r'^0+'), '');
      this.getNoteSuggestions(tempValue);
      setState(() {
        value = tempValue;
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
    String tempValue = value.substring(0, value.length - 1);
    this.getNoteSuggestions(tempValue);
    if (value.length > 0) {
      setState(() {
        value = tempValue;
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
    var tmpValue = newToValue.floor().toString();
    this.getNoteSuggestions(tmpValue);
    setState(() {
      value = tmpValue;
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

  Future<LocationData?> getLocation() async {
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

    try {
      _locationData = await location.getLocation();
      return _locationData;
    } catch (e) {
      print(e);
      throw Exception("Couldn't get data");
    }
  }

  Future<void> addExpense(BuildContext context) async {
    setState(() {
      saving = true;
    });

    await Future.delayed(panelTransition);
    double iconHeight = getIconHeight(MediaQuery.of(context)) * 0.66;

    AppColors colors = get(context);

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

    //checking location\
    if (useLocation) {
      setState(() {
        savingIcon = FaIcon(FontAwesomeIcons.locationArrow, color: colors.iconOnMain, size: iconHeight, key: Key('location'));
      });
      try {
        LocationData? locationData = await getLocation().timeout(Duration(seconds: LOCATION_TIMEOUT), onTimeout: () => null);
        if (locationData != null) {
          expense.latitude = locationData.latitude;
          expense.longitude = locationData.longitude;
        }
      } catch (e) {
        showAlertDialog(context, 'Error getting Location', e.toString());
        return;
      }
    }

    setState(() {
      savingIcon = FaIcon(
        FontAwesomeIcons.cloudUploadAlt,
        color: colors.iconOnMain,
        size: iconHeight,
        key: Key('upload'),
      );
    });

    await service.addExpense(expense);
    closeDialog();
  }

  void closeDialog() {
    Navigator.pop(context);
  }

  double getIconHeight(MediaQueryData mq) {
    return min(mq.size.height / 6, 150);
  }

  Widget getIconHeader(BuildContext context) {
    double iconHeight = getIconHeight(MediaQuery.of(context));

    AppColors colors = get(context);

    if (saving && savingIcon != null) {
      return savingIcon!;
    } else {
      return getIcon(widget.category.icon!, size: iconHeight * 0.66, color: colors.iconOnMain);
    }
  }

  double getHeaderHeight(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);

    return min(mq.size.height / 6, 150.toDouble());
  }

  @override
  Widget build(BuildContext context) {

    AppColors colors = get(context);

    return Container(
      alignment: Alignment.center,
      color: colors.background.withOpacity(0),
      padding: EdgeInsets.all(0),
      child: Container(
        constraints: BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          borderRadius: defaultBorder,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: panelTransition,
                switchOutCurve: Curves.easeInOutQuart,
                switchInCurve: Curves.easeInOutQuart,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: saving
                    ? Container(
                        key: Key("saving"),
                        height: 150,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(gradient: defaultGradient(context), borderRadius: defaultBorder),
                        child: Hero(
                            tag: widget.category.icon!,
                            child: DummyFade(
                                running: saving,
                                child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 130),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return ScaleTransition(scale: animation, child: child);
                                    },
                                    switchInCurve: Curves.easeInOutQuart,
                                    switchOutCurve: Curves.easeInOutQuart,
                                    child: getIconHeader(context)))),
                      )
                    : Container(
                        key: Key("input"),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: defaultBorder,
                          color: colors.dialogBackground,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: getHeaderHeight(context),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(gradient: defaultGradient(context), borderRadius: BorderRadius.vertical(top: defaultBorder.topLeft)),
                                  child: Hero(tag: widget.category.icon!, child: getIconHeader(context)),
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
                                          color: colors.iconOnMain,
                                          size: 20,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: defaultBorder,
                                  color: colors.expenseInputBackground,
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
                                                child: Text(valueToStr(value), style: TextStyle(fontSize: 20, color: colors.expenseInput)),
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
                              noteSuggestions: noteSuggestions,
                              expenseDate: expenseDate,
                              setDate: (date) {
                                setState(() {
                                  expenseDate = date;
                                });
                              },
                              setNote: (note) {
                                setState(() {
                                  expenseNote = note;
                                  noteSuggestions = [];
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: PlatformElevatedButton(
                                    color: colors.main,
                                    onPressed: value.length > 0 ? () => addExpense(context) : null,
                                    child: Text('Save'),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        }),
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
