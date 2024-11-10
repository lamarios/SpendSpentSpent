// This file is "main.dart"
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/expenses/models/currency_conversion.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

import '../../expenses/models/expense.dart';

part 'add_expense_dialog.freezed.dart';

class AddExpenseDialogCubit extends Cubit<AddExpenseDialogState> {
  final Category category;
  final LastExpenseCubit lastExpenseCubit;
  final noteController = TextEditingController();
  final suggestionController = ScrollController();

  AddExpenseDialogCubit(super.initialState,
      {required this.category, required this.lastExpenseCubit}) {
    init();
    noteController.addListener(() {
      setNote(noteController.text);
    });
  }

  @override
  close() async {
    noteController.dispose();
    suggestionController.dispose();
    super.close();
  }

  void getNoteSuggestions(String value) {
    EasyDebounce.debounce(
        'new-expense-note-suggestions', const Duration(milliseconds: 500),
        () async {
      final suggestions = await service.getNoteSuggestions(Expense(
          amount: double.parse(valueToStr(value)),
          date: '2022-01-23',
          category: category));
      List<String> results = suggestions.keys.toList(growable: false);
      results.sort((a, b) => suggestions[b]!.compareTo(suggestions[a]!));

      emit(state.copyWith(noteSuggestions: results));
    });
  }

  init() async {
    var useLocation = await Preferences.getBool(Preferences.EXPENSE_LOCATION);
    emit(state.copyWith(useLocation: useLocation));

    if (useLocation) {
      getLocation()
          .timeout(const Duration(seconds: LOCATION_TIMEOUT),
              onTimeout: () => null)
          .then((loc) {
        emit(state.copyWith(location: loc));
      });
    }
  }

  void addNumber(String i) {
    if (state.currencyConversion == null) {
      String tempValue = (state.value + i).replaceFirst(RegExp(r'^0+'), '');
      getNoteSuggestions(tempValue);
      emit(state.copyWith(value: tempValue));
    } else {
      emit(state.copyWith(
          valueFrom: (state.valueFrom + i).replaceFirst(RegExp(r'^0+'), '')));
      calculateRateConversion();
    }
  }

  void calculateRateConversion() {
    var from = state.valueFrom.isNotEmpty ? state.valueFrom : "0";
    double rate = state.currencyConversion?.rate ?? 1;
    double fromDouble = double.parse(from);
    var newToValue = fromDouble * rate;
    var tmpValue = newToValue.floor().toString();
    getNoteSuggestions(tmpValue);
    emit(state.copyWith(value: tmpValue));
  }

  String valueToStr(String from) {
    String str = from.padLeft(3, '0');
    List<String> split = str.split('');
    split.insert(split.length - 2, '.');

    str = split.join('');

    return str;
  }

  void setLocation(bool location) {
    Preferences.setBool(Preferences.EXPENSE_LOCATION, location);
    emit(state.copyWith(useLocation: location));

    if (state.useLocation) {
      getLocation()
          .timeout(const Duration(seconds: LOCATION_TIMEOUT),
              onTimeout: () => null)
          .then((loc) {
        emit(state.copyWith(location: loc));
      });
    }
  }

  void removeNumber() {
    String tempValue = state.value.substring(0, state.value.length - 1);
    getNoteSuggestions(tempValue);
    if (state.value.isNotEmpty) {
      emit(state.copyWith(value: tempValue));
    }
    if (state.valueFrom.isNotEmpty) {
      emit(state.copyWith(
          valueFrom: state.valueFrom.substring(0, state.valueFrom.length - 1)));
    }
  }

  void setCurrencyConversion(CurrencyConversion currencyConversion) {
    emit(state.copyWith(currencyConversion: currencyConversion));
    calculateRateConversion();
  }

  Future<void> addExpense(double iconHeight, Color iconColor) async {
    emit(state.copyWith(saving: true));

    await Future.delayed(panelTransition);
    // double iconHeight = getIconHeight(MediaQuery.of(context)) * 0.66;

    var amount = double.parse(valueToStr(state.value));
    var date = DateFormat('yyyy-MM-dd').format(state.expenseDate);
    var note = state.expenseNote;
    if (state.currencyConversion != null) {
      if (note.isNotEmpty) {
        note += "\n";
      }
      note +=
          '${state.currencyConversion?.from} ${valueToStr(state.valueFrom)} -> ${state.currencyConversion?.to}';
    }
    var expense =
        Expense(amount: amount, category: category, date: date, note: note);

    //checking location\
    if (state.useLocation) {
      emit(state.copyWith(
          savingIcon: Icon(Icons.near_me,
              color: iconColor, size: iconHeight, key: const Key('location'))));
      try {
        LocationData? locationData = state.location ??
            await getLocation().timeout(
                const Duration(seconds: LOCATION_TIMEOUT),
                onTimeout: () => null);
        if (locationData != null) {
          expense = expense.copyWith(
              latitude: locationData.latitude,
              longitude: locationData.longitude);
        }
      } catch (e, s) {
        emit(state.copyWith(error: e, stackTrace: s));
        rethrow;
      }
    }

    emit(state.copyWith(
        savingIcon: Icon(
      Icons.cloud_upload,
      color: iconColor,
      size: iconHeight,
      key: const Key('upload'),
    )));
    try {
      await service.addExpense(expense);
      lastExpenseCubit.refresh();
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    }
  }

  Future<LocationData?> getLocation() async {
    emit(state.copyWith(gettingLocation: true));
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service not enabled');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location not allowed');
      }
    }

    try {
      locationData = await location.getLocation();
      return locationData;
    } catch (e) {
      print(e);
      throw Exception("Couldn't get data");
    } finally {
      emit(state.copyWith(gettingLocation: false));
    }
  }

  setDate(DateTime date) {
    emit(state.copyWith(expenseDate: date));
  }

  setNote(String note) {
    emit(state.copyWith(expenseNote: note));
    suggestionController.animateTo(0,
        duration: animationDuration, curve: animationCurve);
  }

  enableCurrencyConversion(bool enable) {
    emit(state.copyWith(
        showCurrencyConversion: enable,
        currencyConversion: enable ? state.currencyConversion : null));
  }
}

@freezed
class AddExpenseDialogState with _$AddExpenseDialogState implements WithError {
  @Implements<WithError>()
  const factory AddExpenseDialogState({
    @Default("") String value,
    @Default("") String valueFrom,
    required DateTime expenseDate,
    @Default('') String expenseNote,
    @Default(false) bool gettingLocation,
    @Default(false) bool useLocation,
    CurrencyConversion? currencyConversion,
    @Default(false) bool showCurrencyConversion,
    @Default(false) bool saving,
    Widget? savingIcon,
    @Default([]) List<String> noteSuggestions,
    LocationData? location,
    dynamic error,
    StackTrace? stackTrace,
  }) = _AddExpenseDialogState;
}
