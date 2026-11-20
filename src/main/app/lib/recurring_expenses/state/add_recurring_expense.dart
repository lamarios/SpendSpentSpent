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
/// year ago, and when editing only after the last occurrence, which is booked already. One chosen before midnight stays
/// included after it, the date picker fails when its initial date is out of the range.
({DateTime first, DateTime last}) firstOccurrenceRange(DateTime? firstOccurrence, DateTime now, {DateTime? after}) {
  var first = DateTime(now.year - 1, now.month, now.day + 1);
  if (after != null && !after.isBefore(first)) {
    first = DateTime(after.year, after.month, after.day + 1);
  }
  return (
    first: firstOccurrence != null && firstOccurrence.isBefore(first) ? firstOccurrence : first,
    last: DateTime(now.year + 2, 12, 31),
  );
}

/// The dialog's state to edit the recurring expense.
AddRecurringExpenseState editRecurringExpenseState(RecurringExpense expense) => AddRecurringExpenseState(
  category: expense.category,
  type: expense.type,
  typeParam: expense.typeParam,
  amount: (expense.amount * 100).round().toString(),
  name: expense.name,
);

class AddRecurringExpenseCubit extends Cubit<AddRecurringExpenseState> {
  /// The recurring expense being edited, none when adding one.
  final RecurringExpense? editing;
  late final TextEditingController nameController = TextEditingController(text: state.name);

  AddRecurringExpenseCubit(super.initialState, {this.editing}) {
    getCategories();
    if (service.config == null) {
      _loadConfig();
    } else if (editing != null) {
      emit(state.copyWith(firstOccurrence: _defaultFirstOccurrence(state.type, state.typeParam)));
    }

    nameController.addListener(() {
      setName(nameController.value.text);
    });
  }

  @override
  Future<void> close() async {
    nameController.dispose();
    await super.close();
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

  /// Whether the schedule can be changed: older servers keep the next occurrence of a recurring expense when it
  /// changes.
  bool get canEditSchedule => editing == null || (service.config?.canEditRecurringSchedule ?? false);

  bool _scheduleChanged(int? type, int? typeParam) =>
      type != editing!.type || (type != 0 && typeParam != editing!.typeParam);

  /// None when the server doesn't say it takes the first occurrence into account, older ones ignore it and start at
  /// the next occurrence from today on. Without one it isn't shown. When editing, the server keeps the next occurrence
  /// as long as the schedule stays, and starts a new one at its next occurrence from today on, like a new recurring
  /// expense, but after the last one, which might be today.
  DateTime? _defaultFirstOccurrence(int? type, int? typeParam) {
    final expense = editing;
    if (expense == null) {
      return (service.config?.canChooseRecurringFirstOccurrence ?? false)
          ? defaultFirstOccurrence(type, typeParam, DateTime.now())
          : null;
    }
    // older servers keep it, it's shown without the date picker then
    if (!canEditSchedule || !_scheduleChanged(type, typeParam)) {
      return expense.nextOccurrence != null ? DateTime.parse(expense.nextOccurrence!) : null;
    }
    final now = DateTime.now();
    final last = lastOccurrence;
    return defaultFirstOccurrence(
      type,
      typeParam,
      last != null && !last.isBefore(_day(now)) ? DateTime(last.year, last.month, last.day + 1) : now,
    );
  }

  /// The last occurrence of the recurring expense being edited, the next one must be after it.
  DateTime? get lastOccurrence => editing?.lastOccurrence != null ? DateTime.parse(editing!.lastOccurrence!) : null;

  Future<void> save() => editing == null ? addRecurringExpense() : updateRecurringExpense();

  Future<void> updateRecurringExpense() async {
    final expense = editing!;
    double doubleAmount = double.parse(state.amount) / 100;
    int? typeParam = state.type == 0 ? 0 : state.typeParam;

    if (state.category != null && state.type != null && typeParam != null && doubleAmount > 0) {
      // without a chosen one, the server keeps its own, which the background job might have moved meanwhile, or
      // calculates it for a new schedule
      final nextOccurrence = state.firstOccurrenceChosen && state.firstOccurrence != null
          ? _dateFormat.format(state.firstOccurrence!)
          : null;
      await service.updateRecurringExpense(
        expense.copyWith(
          category: state.category!,
          amount: doubleAmount,
          name: state.name,
          type: state.type!,
          typeParam: typeParam,
          nextOccurrence: nextOccurrence,
        ),
      );
    } else {
      print('Missing parameters');
    }
  }

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
    if (!canEditSchedule) {
      return;
    }
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
    if (!canEditSchedule) {
      return;
    }
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
    // the keypad's cents, saving ignores 0
    2 => (int.tryParse(amount) ?? 0) > 0,
    _ => false,
  };
}
