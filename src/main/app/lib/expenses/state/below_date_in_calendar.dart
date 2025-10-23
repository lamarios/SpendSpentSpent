import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/expenses/services/history_service.dart';
import 'package:spend_spent_spent/globals.dart';

part 'below_date_in_calendar.freezed.dart';

class BelowDateInCalendarCubit extends Cubit<BelowDateInCalendarState> {
  final DateTime date;

  BelowDateInCalendarCubit(super.initialState, this.date) {
    getMonthExpenses();
  }

  Future<void> getMonthExpenses() async {
    EasyDebounce.debounce(
      'calendar-debounce-${date.month}',
      Duration(milliseconds: 500),
      () async {
        var total = await service.getMonthTotal(
          int.parse(
            '${date.year}-${date.month.toString().padLeft(2, '0')}'.replaceAll(
              '-',
              '',
            ),
          ),
        );
        if (!isClosed) {
          emit(state.copyWith(loading: false, amount: total));
        }
      },
    );
  }
}

@freezed
sealed class BelowDateInCalendarState with _$BelowDateInCalendarState {
  const factory BelowDateInCalendarState({
    @Default(true) bool loading,
    double? amount,
  }) = _BelowDateInCalendarState;
}
