library app.globals;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/service.dart';

Service service = Service();
const MIN_BACKEND_VERSION = 67;
final getIt = GetIt.instance;

const BorderRadius defaultBorder = BorderRadius.all(Radius.circular(15));
const defaultPadding = 20.0;
const panelTransition = Duration(milliseconds: 350);
const animationDuration = Duration(milliseconds: 250);
const animationCurve = Curves.easeInOutQuad;

// broadcast message types
const BROADCAST_LOGGED_IN = 'loggedIn',
    BROADCAST_REFRESH_CATEGORIES = 'refreshCategories',
    NEED_LOGIN = 'needLogin',
    BROADCAST_LOGGED_OUT = 'loggedOut',
    BROADCAST_REFRESH_EXPENSES = 'refreshExpenses';

const TABLET = 768.0;
const BIG_PHONE = 500;

ButtonStyle flatButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.blue[800],
  padding: const EdgeInsets.symmetric(vertical: 5.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

int columnCount(MediaQueryData data) {
  if (isTablet(data)) {
    return 7;
  } else if (isBigPhone(data)) {
    return 5;
  } else {
    return 4;
  }
}

bool isTablet(MediaQueryData data) {
  return data.size.width >= TABLET;
}

bool isBigPhone(MediaQueryData data) {
  return data.size.width > BIG_PHONE;
}

String formatCurrency(double amount) {
  return NumberFormat.currency(decimalDigits: 2, symbol: '').format(amount);
}

void setStatusBarColor(Color color, Brightness text) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color, statusBarIconBrightness: text));
}
