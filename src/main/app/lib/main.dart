import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/screens/homeScreen.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

void main() {
  runApp(SpendSpentSpent());
}

class SpendSpentSpent extends StatelessWidget {
  ThemeData generateTheme(BuildContext context, AppColors colors) {
    return ThemeData(
        primarySwatch: colors.materialColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: colors.text, displayColor: colors.text),
        backgroundColor: colors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            shape: StadiumBorder(),
            backgroundColor: colors.background,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: colors.dialogBackground),
        buttonTheme: ButtonThemeData(buttonColor: colors.mainDark, textTheme: ButtonTextTheme.primary),
        dialogTheme: DialogTheme(
            backgroundColor: colors.dialogBackground, contentTextStyle: TextStyle(color: colors.text), titleTextStyle: TextStyle(color: colors.text, fontWeight: FontWeight.bold, fontSize: 15)),
        cardTheme: CardTheme(color: colors.dialogBackground));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final materialTheme = generateTheme(context, COLORS[Brightness.light]!);
    final dark = COLORS[Brightness.dark]!;

    return Theme(
      data: materialTheme,
      child: PlatformProvider(
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true, platformStyle: PlatformStyleData(ios: PlatformStyle.Material)),
        builder: (context) => PlatformApp(
          title: 'SpendSpentSpent',
          home: Material(child: HomeScreen()),
          material: (_, __) => MaterialAppData(
              theme: materialTheme,
              darkTheme: ThemeData.dark().copyWith(
                  primaryColor: dark.main,
                  dialogBackgroundColor: dark.dialogBackground,
                  backgroundColor: dark.background,
                  buttonTheme: ButtonThemeData(buttonColor: dark.mainDark, textTheme: ButtonTextTheme.primary),
                  textTheme: Theme.of(context).textTheme.apply(bodyColor: dark.text, displayColor: dark.text),
                  primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: dark.main, displayColor: dark.main),
                  switchTheme: materialTheme.switchTheme.copyWith(
                    thumbColor: MaterialStateProperty.resolveWith((set) {
                      if (set.contains(MaterialState.disabled)) {
                        return dark.text.withOpacity(0.5);
                      }
                      if (set.contains(MaterialState.selected)) {
                        return dark.main;
                      }
                      return dark.text;
                    }),
                    trackColor: MaterialStateProperty.resolveWith((set) {
                      if (set.contains(MaterialState.disabled)) {
                        return dark.text.withOpacity(0.1);
                      }
                      if (set.contains(MaterialState.selected)) {
                        return dark.main.withOpacity(0.3);
                      }
                      return dark.text.withOpacity(0.3);
                    }),
                  ),
                  cardTheme: CardTheme(color: dark.dialogBackground),
                  appBarTheme: AppBarTheme(backgroundColor: dark.main),
                  colorScheme: ColorScheme.fromSwatch(
                      primarySwatch: dark.materialColor,
                      backgroundColor: dark.background,
                      accentColor: dark.main,
                      brightness: Brightness.dark,
                      primaryColorDark: dark.gradientDark,
                      cardColor: dark.dialogBackground))),
          cupertino: (_, __) => CupertinoAppData(theme: CupertinoThemeData(primaryColor: materialTheme.primaryColor)),
        ),
      ),
    );
  }
}
