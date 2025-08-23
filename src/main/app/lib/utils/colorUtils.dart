import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

/*
final Map<Brightness, AppColors> COLORS = {
  Brightness.light: AppColors(
      materialColor: Colors.blue,
      announcement: Colors.amberAccent.shade100,
      announcementText: Colors.grey.shade800,
      main: Colors.blue,
      mainDark: Colors.blue.shade800,
      iconOnMain: Colors.white,
      background: Colors.white,
      gradientDark: Colors.blue.shade600,
      expenseInputBackground: Colors.grey.shade200,
      expenseInput: Colors.grey.shade800,
      dialogBackground: Colors.white,
      mainButton: Colors.blue,
      text: Colors.grey.shade800,
      buttonText: Colors.white,
      textOnMain: Colors.white,
      dummy: Colors.grey.shade200,
      statsBackground: Colors.grey.shade300,
      textOnDarkMain: Colors.white,
      containerOnDialogBackground: Colors.grey.shade300,
      cancelText: Colors.grey.shade700),
  Brightness.dark: AppColors(
      statsBackground: Colors.grey.shade900,
      announcement: Colors.amberAccent.shade100,
      announcementText: Colors.grey.shade800,
      iconOnMain: Colors.blue.shade900,
      mainDark: Colors.blue.shade800,
      background: Colors.black,
      materialColor: Colors.blue,
      main: Colors.blue,
      containerOnDialogBackground: Colors.grey.shade800,
      dummy: Colors.grey.shade800,
      textOnMain: Colors.blue.shade900,
      buttonText: Colors.blue.shade900,
      gradientDark: Colors.blue.shade600,
      expenseInputBackground: Colors.grey.shade800,
      expenseInput: Colors.grey.shade400,
      dialogBackground: Colors.grey.shade900,
      mainButton: Colors.blue.shade700,
      text: Colors.grey.shade400,
      textOnDarkMain: Colors.grey.shade400,
      cancelText: Colors.grey.shade400),
};
*/

/*
AppColors get(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return COLORS[brightness]!;
  // return COLORS[Brightness.dark]!;
}
*/

LinearGradient defaultGradient(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  return LinearGradient(
    colors: [colors.primary.darken(10), colors.primary],
    stops: const [0, 0.5],
    begin: Alignment.bottomCenter,
    end: Alignment.topRight,
  );
}

Color darken(Color color, [double amount = .1]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

Color brighten(Color color, [double amount = .1]) {
  final hsl = HSLColor.fromColor(color);
  final hslBright = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslBright.toColor();
}
