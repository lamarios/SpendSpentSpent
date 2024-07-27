import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/currency_converter.dart';
import 'package:spend_spent_spent/expenses/models/currency_conversion.dart';
import 'package:spend_spent_spent/globals.dart';

const CURRENCIES = [
  "AUD",
  "BGN",
  "BRL",
  "CAD",
  "CHF",
  "CNY",
  "CZK",
  "DKK",
  "EUR",
  "GBP",
  "HKD",
  "HRK",
  "HUF",
  "IDR",
  "ILS",
  "INR",
  "ISK",
  "JPY",
  "KRW",
  "MXN",
  "MYR",
  "NOK",
  "NZD",
  "PHP",
  "PLN",
  "RON",
  "RUB",
  "SEK",
  "SGD",
  "THB",
  "TRY",
  "USD",
  "ZAR"
];

class CurrencyConverter extends StatelessWidget {
  final CurrencyConversion? currencyConversion;
  final String value, valueFrom;
  final Function(String from) valueToStr;
  final Function(CurrencyConversion conversion) setCurrencyConversion;

  const CurrencyConverter(
      {super.key,
      this.currencyConversion,
      required this.value,
      required this.valueFrom,
      required this.valueToStr,
      required this.setCurrencyConversion});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (BuildContext context) => CurrencyConverterCubit(
          const CurrencyConverterState(), setCurrencyConversion),
      child: BlocBuilder<CurrencyConverterCubit, CurrencyConverterState>(
          builder: (context, state) {
        final cubit = context.read<CurrencyConverterCubit>();

        return Container(
            height: 70,
            decoration: BoxDecoration(
                color: colors.secondaryContainer, borderRadius: defaultBorder),
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        DropdownButton(
                            value: state.fromCurrency,
                            onChanged: cubit.changeFromCurrency,
                            dropdownColor: colors.secondaryContainer,
                            items: CURRENCIES
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: colors.onSecondaryContainer),
                                  ));
                            }).toList()),
                        Text('${valueToStr(valueFrom)}',
                            style: TextStyle(
                                fontSize: 20,
                                color: colors.onSecondaryContainer)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        DropdownButton(
                            value: state.toCurrency,
                            dropdownColor: colors.secondaryContainer,
                            onChanged: cubit.changeToCurrency,
                            items: CURRENCIES
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: colors.onSecondaryContainer),
                                  ));
                            }).toList()),
                        Text('${valueToStr(value)}',
                            style: TextStyle(
                                fontSize: 20,
                                color: colors.onSecondaryContainer)),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
