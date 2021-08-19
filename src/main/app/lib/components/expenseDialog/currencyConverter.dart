import 'package:after_layout/after_layout.dart';
import 'package:app/globals.dart';
import 'package:app/models/currencyConversion.dart';
import 'package:app/utils/preferences.dart';
import 'package:flutter/material.dart';

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

class CurrencyConverter extends StatefulWidget {
  CurrencyConversion? currencyConversion;
  String value, valueFrom;
  Function valueToStr, setCurrencyConversion;

  CurrencyConverter(
      {this.currencyConversion,
      required this.value,
      required this.valueFrom,
      required this.valueToStr,
      required this.setCurrencyConversion});

  @override
  CurrencyConverterState createState() => CurrencyConverterState();
}

class CurrencyConverterState extends State<CurrencyConverter>
    with AfterLayoutMixin<CurrencyConverter> {
  String fromCurrency = CURRENCIES[0];
  String toCurrency = CURRENCIES[1];

  void changeFromCurrency(String? currency) {
    var newCurrency = currency ?? CURRENCIES[0];
    Preferences.set(Preferences.FROM_CURRENCY, newCurrency);
    setState(() {
      fromCurrency = newCurrency;
      setCurrency();
    });
  }

  void changeToCurrency(String? currency) {
    var newCurrency = currency ?? CURRENCIES[1];
    Preferences.set(Preferences.TO_CURRENCY, newCurrency);
    setState(() {
      toCurrency = newCurrency;
      setCurrency();
    });
  }

  Future<void> setCurrency() async {
    var rate = await service.getCurrencyRate(fromCurrency, toCurrency);
    var currency =
        CurrencyConversion(from: fromCurrency, to: toCurrency, rate: rate);
    widget.setCurrencyConversion(currency);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 70,
        color: Colors.grey[350],
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
                        value: fromCurrency,
                        onChanged: changeFromCurrency,
                        items: CURRENCIES
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList()),
                    Text('${widget.valueToStr(widget.valueFrom)}',
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    DropdownButton(
                        value: toCurrency,
                        onChanged: changeToCurrency,
                        items: CURRENCIES
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList()),
                    Text('${widget.valueToStr(widget.value)}',
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var from = await Preferences.get(Preferences.FROM_CURRENCY, CURRENCIES[0]);
    var to = await Preferences.get(Preferences.TO_CURRENCY, CURRENCIES[1]);

    setState(() {
      fromCurrency = from;
      toCurrency = to;
      setCurrency();
    });
  }
}
