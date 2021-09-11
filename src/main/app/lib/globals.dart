library app.globals;

import 'dart:ui';

import 'package:spend_spent_spent/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

Service service = new Service();

const BorderRadius defaultBorder = BorderRadius.all(Radius.circular(15));
const defaultPadding = 20.0;
const panelTransition = Duration(milliseconds: 350);

// broadcast message types
const BROADCAST_LOGGED_IN = 'loggedIn', BROADCAST_REFRESH_CATEGORIES = 'refreshCategories', NEED_LOGIN = 'needLogin', BROADCAST_LOGGED_OUT = 'loggedOut', BROADCAST_REFRESH_EXPENSES = 'refreshExpenses';

ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  backgroundColor: Colors.blue[800],
  padding: EdgeInsets.symmetric(vertical: 5.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

bool isTablet(MediaQueryData data){
  return data.size.width > 768;
}

String formatCurrency(double amount) {
  return NumberFormat.currency(decimalDigits: 2, symbol: '').format(amount);
}
