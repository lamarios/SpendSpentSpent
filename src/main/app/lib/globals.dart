library app.globals;

import 'dart:ui';

import 'package:app/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Service service = new Service();

const BorderRadius defaultBorder = BorderRadius.all(Radius.circular(15));
const defaultPadding = 20.0;
const panelTransition = Duration(milliseconds: 350);


// broadcast message types
const BROADCAST_LOGGED_IN='loggedIn';

ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  backgroundColor: Colors.blue[800],
  padding: EdgeInsets.symmetric(vertical: 5.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);
