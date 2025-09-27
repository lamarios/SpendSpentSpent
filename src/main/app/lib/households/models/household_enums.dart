import 'dart:ui';

import 'package:flutter/material.dart';

enum HouseholdInviteStatus { accepted, pending }

enum HouseholdColor {
  green(Colors.green),
  red(Colors.red),
  orange(Colors.orange),
  yellow(Colors.yellow),
  purple(Colors.purple),
  pink(Colors.pink),
  brown(Colors.brown),
  cyan(Colors.cyan),
  teal(Colors.teal),
  lime(Colors.lime);

  final Color color;

  const HouseholdColor(this.color);

  ColorScheme getColor(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return ColorScheme.fromSeed(seedColor: color, brightness: brightness);
  }
}
