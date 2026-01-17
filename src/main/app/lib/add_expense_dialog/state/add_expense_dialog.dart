// This file is "main.dart"
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/models/currency_conversion.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

import '../../expenses/models/expense.dart';

part 'add_expense_dialog.freezed.dart';

const expenseDateFormat = 'yyyy-MM-dd';

class AddExpenseDialogCubit extends Cubit<AddExpenseDialogState> {
  final LastExpenseCubit lastExpenseCubit;
  final suggestionController = ScrollController();
  final Expense? expense;

  CarouselController carouselController = CarouselController();

  AddExpenseDialogCubit(super.initialState, {required this.lastExpenseCubit, this.expense}) {
    init();
  }

  @override
  close() async {
    suggestionController.dispose();
    carouselController.dispose();
    super.close();
  }

  void getNoteSuggestions(String value) {
    EasyDebounce.debounce('new-expense-note-suggestions', const Duration(milliseconds: 500), () async {
      final suggestions = await service.getNoteSuggestions(
        Expense(
          amount: double.parse(valueToStr(value)),
          date: '2022-01-23',
          category: state.category,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      List<String> results = suggestions.keys.toList(growable: false);
      results.sort((a, b) => suggestions[b]!.compareTo(suggestions[a]!));

      emit(state.copyWith(noteSuggestions: results));
    });
  }

  Future<void> init() async {
    var useLocation = await Preferences.getBool(Preferences.EXPENSE_LOCATION);
    emit(state.copyWith(useLocation: useLocation));

    if (useLocation && (expense?.id == null)) {
      getLocation().timeout(const Duration(seconds: LOCATION_TIMEOUT), onTimeout: () => null).then((loc) {
        if (!isClosed) {
          emit(state.copyWith(location: loc));
        }
      });
    }
    if (expense != null) {
      // we init our state with the current state of our edited expense.

      var value = formatCurrency(expense!.amount).replaceAll(".", "").replaceAll(",", "");
      var fromMap = Position.fromMap({'longitude': expense!.longitude, 'latitude': expense!.latitude});
      emit(
        state.copyWith(
          files: expense!.files,
          expenseDate: DateTime.fromMillisecondsSinceEpoch(expense!.timestamp),
          value: value,
          expenseNote: expense!.note ?? '',
          location: fromMap,
        ),
      );

      getNoteSuggestions(value);
    }
  }

  void addNumber(String i) {
    if (state.currencyConversion == null) {
      String tempValue = (state.value + i).replaceFirst(RegExp(r'^0+'), '');
      getNoteSuggestions(tempValue);
      emit(state.copyWith(value: tempValue));
    } else {
      emit(state.copyWith(valueFrom: (state.valueFrom + i).replaceFirst(RegExp(r'^0+'), '')));
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
      getLocation().timeout(const Duration(seconds: LOCATION_TIMEOUT), onTimeout: () => null).then((loc) {
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
      emit(state.copyWith(valueFrom: state.valueFrom.substring(0, state.valueFrom.length - 1)));
    }
  }

  void setCurrencyConversion(CurrencyConversion currencyConversion) {
    emit(state.copyWith(currencyConversion: currencyConversion));
    calculateRateConversion();
  }

  Future<Expense> addExpense(double iconHeight, Color iconColor) async {
    emit(state.copyWith(saving: true));

    var amount = double.parse(valueToStr(state.value));
    var date = DateFormat(expenseDateFormat).format(state.expenseDate);
    var note = state.expenseNote;
    if (state.currencyConversion != null) {
      if (note.isNotEmpty) {
        note += "\n";
      }
      note += '${state.currencyConversion?.from} ${valueToStr(state.valueFrom)} -> ${state.currencyConversion?.to}';
    }
    var expense = Expense(
      amount: amount,
      category: state.category,
      date: date,
      note: note,
      files: state.files,
      id: this.expense?.id,
      type: this.expense?.type ?? 1,
      timestamp: state.expenseDate.millisecondsSinceEpoch,
    );

    //checking location
    // but only if we're not editing an expense
    if (this.expense?.id == null && state.useLocation) {
      try {
        Position? locationData =
            state.location ??
            await getLocation().timeout(const Duration(seconds: LOCATION_TIMEOUT), onTimeout: () => null);
        if (locationData != null) {
          expense = expense.copyWith(latitude: locationData.latitude, longitude: locationData.longitude);
        }
      } catch (e, s) {
        emit(state.copyWith(error: e, stackTrace: s));
        rethrow;
      }
    } else if (this.expense != null) {
      expense = expense.copyWith(latitude: state.location?.latitude, longitude: state.location?.longitude);
    }

    try {
      final result = await service.addExpense(expense.copyWith(category: state.category));
      lastExpenseCubit.refresh();
      return result;
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    }
  }

  void setCategory(Category cat) {
    emit(state.copyWith(category: cat));
    getNoteSuggestions(state.value);
  }

  Future<Position?> getLocation() async {
    emit(state.copyWith(gettingLocation: true));
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      throw Exception("Couldn't get data");
    } finally {
      if (!isClosed) {
        emit(state.copyWith(gettingLocation: false));
      }
    }
  }

  void setDate(DateTime date) {
    emit(state.copyWith(expenseDate: date));
  }

  void setNote(String note) {
    emit(state.copyWith(expenseNote: note));
    suggestionController.animateTo(0, duration: animationDuration, curve: animationCurve);
  }

  void enableCurrencyConversion(bool enable) {
    emit(state.copyWith(showCurrencyConversion: enable, currencyConversion: enable ? state.currencyConversion : null));
  }

  void setImages(List<SssFile> list) {
    emit(state.copyWith(files: list));
  }

  void setFiles(List<SssFile> files) {
    emit(state.copyWith(files: files));
  }

  void setAmount(String text) {
    emit(state.copyWith(value: text.replaceAll(".", "").replaceAll(",", "")));
  }

  void updateFile(SssFile file) {
    final List<SssFile> files = List.from(state.files);
    final index = files.indexWhere((element) => element.id == file.id);
    files[index] = file;
    emit(state.copyWith(files: files));
  }
}

@freezed
sealed class AddExpenseDialogState with _$AddExpenseDialogState implements WithError {
  @Implements<WithError>()
  const factory AddExpenseDialogState({
    required Category category,
    @Default("") String value,
    @Default("") String valueFrom,
    required DateTime expenseDate,
    @Default('') String expenseNote,
    @Default(false) bool gettingLocation,
    @Default(false) bool useLocation,
    CurrencyConversion? currencyConversion,
    @Default(false) bool showCurrencyConversion,
    @Default(false) bool saving,
    @Default([]) List<String> noteSuggestions,
    @Default([]) List<SssFile> files,
    Position? location,
    dynamic error,
    StackTrace? stackTrace,
  }) = _AddExpenseDialogState;

  const AddExpenseDialogState._();

  List<String> get aiAndNoteSuggestions {
    final List<String> notes = List.from(possibleTags);
    notes.addAll(noteSuggestions);

    return notes.toSet().toList();
  }

  List<double> get possiblePrices {
    return files.map((e) => e.amounts).expand((element) => element).toSet().toList();
  }

  List<String> get possibleTags {
    return files.map((e) => e.aiTags).expand((element) => element).toSet().toList();
  }
}
