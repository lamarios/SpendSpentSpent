import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/currency_converter.dart';
import 'package:spend_spent_spent/expenses/models/currency_conversion.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

import '../../globals.dart';

part 'currency_converter.freezed.dart';

class CurrencyConverterCubit extends Cubit<CurrencyConverterState> {
  final Function(CurrencyConversion conversion) setCurrencyConversion;

  CurrencyConverterCubit(super.initialState, this.setCurrencyConversion) {
    init();
  }

  init() async {
    var from = await Preferences.get(Preferences.FROM_CURRENCY, CURRENCIES[0]);
    var to = await Preferences.get(Preferences.TO_CURRENCY, CURRENCIES[1]);
    emit(state.copyWith(fromCurrency: from, toCurrency: to));
    setCurrency();
  }

  Future<void> setCurrency() async {
    var rate = await service.getCurrencyRate(
      state.fromCurrency,
      state.toCurrency,
    );
    var currency = CurrencyConversion(
      from: state.fromCurrency,
      to: state.toCurrency,
      rate: rate,
    );
    setCurrencyConversion(currency);
  }

  void changeFromCurrency(String? currency) {
    var newCurrency = currency ?? CURRENCIES[0];
    Preferences.set(Preferences.FROM_CURRENCY, newCurrency);
    emit(state.copyWith(fromCurrency: newCurrency));
    setCurrency();
  }

  void changeToCurrency(String? currency) {
    var newCurrency = currency ?? CURRENCIES[1];
    Preferences.set(Preferences.TO_CURRENCY, newCurrency);
    emit(state.copyWith(toCurrency: newCurrency));
    setCurrency();
  }
}

@freezed
sealed class CurrencyConverterState with _$CurrencyConverterState {
  const factory CurrencyConverterState({
    @Default("USD") String fromCurrency,
    @Default("EUR") String toCurrency,
  }) = _CurrencyConverterState;
}
