import 'dart:core';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';

import '../../globals.dart';

part 'add_recurring_expense.freezed.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');

DateTime _day(DateTime date) => DateTime(date.year, date.month, date.day);

/// The weekday of a weekly type parameter, which counts from Sunday = 1 like the server.
int _weekday(int typeParam) => ((typeParam + 5) % 7) + 1;

/// Whether the date falls on the schedule: the chosen weekday, day of the month or month. The server only accepts such
/// a first occurrence, the following ones are counted from it. Yearly ones are on the 28th at the latest, like the
/// monthly ones, a yearly one on February 29th would move to the 28th.
bool isOnSchedule(int type, int typeParam, DateTime date) => switch (type) {
  0 => true,
  1 => date.weekday == _weekday(typeParam),
  2 => date.day == typeParam,
  3 => date.month == typeParam + 1 && date.day <= 28,
  _ => false,
};

/// The next occurrence from today on, as the server calculates it when no first occurrence is sent. It's shown until
/// another one is chosen, and isn't sent itself, so nothing changes when it's kept.
DateTime? defaultFirstOccurrence(int? type, int? typeParam, DateTime now) {
  final today = _day(now);
  // DateTime normalizes the day, unlike adding a Duration it isn't shifted by a daylight saving change
  DateTime orLater(DateTime date, {int days = 0, int months = 0}) =>
      date.isBefore(today) ? DateTime(date.year, date.month + months, date.day + days) : date;
  return switch ((type, typeParam)) {
    (0, _) => today,
    // the weekday of the current week, from Monday on like the server
    (1, final int param) => orLater(
      DateTime(today.year, today.month, today.day + _weekday(param) - today.weekday),
      days: 7,
    ),
    (2, final int param) => orLater(DateTime(today.year, today.month, param), months: 1),
    // today in the chosen month, else the 1st of the month this year or next
    (3, final int param) when param + 1 == today.month => today,
    (3, final int param) => DateTime(param + 1 < today.month ? today.year + 1 : today.year, param + 1, 1),
    _ => null,
  };
}

/// The dates the first occurrence can be chosen from. The server books every occurrence since then and accepts up to a
/// year ago. One chosen before midnight stays included after it, the date picker fails when its initial date is out of
/// the range.
({DateTime first, DateTime last}) firstOccurrenceRange(DateTime? firstOccurrence, DateTime now) {
  final first = DateTime(now.year - 1, now.month, now.day + 1);
  return (
    first: firstOccurrence != null && firstOccurrence.isBefore(first) ? firstOccurrence : first,
    last: DateTime(now.year + 2, 12, 31),
  );
}

class AddRecurringExpenseCubit extends Cubit<AddRecurringExpenseState> {
  final TextEditingController nameController = TextEditingController(text: '');

  AddRecurringExpenseCubit(super.initialState) {
    getCategories();
    if (service.config == null) {
      _loadConfig();
    }

    nameController.addListener(() {
      setName(nameController.value.text);
    });
  }

  /// The server config is loaded at start up without being waited for, so the schedule can be chosen before it's
  /// there. The first occurrence is then shown once it arrives.
  Future<void> _loadConfig() async {
    try {
      await service.getCurrentServerConfig();
    } catch (e) {
      // without it, the first occurrence isn't offered and the server starts at the next one from today on
      print('Could not load the server config: $e');
      return;
    }
    if (!isClosed && !state.firstOccurrenceChosen) {
      emit(state.copyWith(firstOccurrence: _defaultFirstOccurrence(state.type, state.typeParam)));
    }
  }

  /// None when the server doesn't say it takes the first occurrence into account, older ones ignore it and start at
  /// the next occurrence from today on. Without one it isn't shown.
  DateTime? _defaultFirstOccurrence(int? type, int? typeParam) =>
      (service.config?.canChooseRecurringFirstOccurrence ?? false)
      ? defaultFirstOccurrence(type, typeParam, DateTime.now())
      : null;

  Future<void> addRecurringExpense() async {
    double doubleAmount = double.parse(state.amount) / 100;
    int? typeParam = state.typeParam;
    if (state.type != null && state.type == 0) {
      typeParam = 0;
    }

    if (state.category != null && state.type != null && typeParam != null && doubleAmount > 0) {
      RecurringExpense expense = RecurringExpense(
        category: state.category!,
        amount: doubleAmount,
        income: false,
        name: state.name,
        typeParam: typeParam,
        type: state.type!,
        // without a chosen one, the server starts at the next occurrence from today on, as it always did
        nextOccurrence: state.firstOccurrenceChosen && state.firstOccurrence != null
            ? _dateFormat.format(state.firstOccurrence!)
            : null,
      );
      await service.addRecurringExpense(expense);
    } else {
      print('Missing parameters');
    }
  }

  getCategories() async {
    final categories = await service.getCategories();
    emit(state.copyWith(categories: categories));
  }

  setCategory(Category category) {
    emit(state.copyWith(category: category));
    /*
    setState(() {
      this.category = category;
      setStepWidget(step);
    });
*/
  }

  setName(String name) {
    emit(state.copyWith(name: name));
  }

  setType(int type) {
    emit(
      state.copyWith(
        type: type,
        typeParam: null,
        firstOccurrence: _defaultFirstOccurrence(type, null),
        firstOccurrenceChosen: false,
      ),
    );
    /*
    setState(() {
      this.type = type;
      this.typeParam = null;
      setStepWidget(step);
    });
*/
  }

  setTypeParam(int typeParam) {
    emit(
      state.copyWith(
        typeParam: typeParam,
        firstOccurrence: _defaultFirstOccurrence(state.type, typeParam),
        firstOccurrenceChosen: false,
      ),
    );
    /*
    setState(() {
      this.typeParam = typeParam;
      setStepWidget(step);
    });
*/
  }

  setAmount(String amount) {
    emit(state.copyWith(amount: amount));
    /*
    setState(() {
      this.amount = amount;
      setStepWidget(step);
    });
*/
  }

  void setStep(int i) {
    emit(state.copyWith(step: i));
  }

  void setFirstOccurrence(DateTime date) {
    emit(state.copyWith(firstOccurrence: _day(date), firstOccurrenceChosen: true));
  }
}

@freezed
sealed class AddRecurringExpenseState with _$AddRecurringExpenseState {
  const factory AddRecurringExpenseState({
    @Default(0) int step,
    Category? category,
    int? type,
    int? typeParam,
    @Default('') String amount,
    @Default('') String name,
    @Default([]) List<Category> categories,
    DateTime? firstOccurrence,
    @Default(false) bool firstOccurrenceChosen,
  }) = _AddRecurringExpenseState;

  const AddRecurringExpenseState._();

  bool get stepValid => switch (step) {
    0 => category != null,
    1 => (type != null && typeParam != null) || (type == 0),
    2 => amount.isNotEmpty,
    _ => false,
  };
}
