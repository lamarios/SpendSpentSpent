import 'package:flutter/material.dart';

class AppColors {
  final Color main,
      mainDark,
      containerOnDialogBackground,
      dummy,
      gradientDark,
      expenseInputBackground,
      expenseInput,
      dialogBackground,
      mainButton,
      text,
      cancelText,
      background,
      iconOnMain,
      buttonText,
      statsBackground,
      textOnMain,
      textOnDarkMain;
  final MaterialColor materialColor;

  AppColors(
      {required this.materialColor,
      required this.textOnDarkMain,
      required this.background,
      required this.containerOnDialogBackground,
      required this.statsBackground,
      required this.buttonText,
      required this.iconOnMain, // color of the icon when it is displayed above the main color
      required this.main,
      required this.textOnMain,
      required this.gradientDark,
      required this.dummy,
      required this.expenseInputBackground,
      required this.expenseInput,
      required this.dialogBackground,
      required this.mainButton,
      required this.text,
      required this.cancelText,
      required this.mainDark});
}
