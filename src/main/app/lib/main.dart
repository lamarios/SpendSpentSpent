import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(SpendSpentSpent());
}

class SpendSpentSpent extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final materialTheme = ThemeData(
      primarySwatch: Colors.blue,
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      backgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(defaultPadding * 0.75),
          shape: StadiumBorder(),
          backgroundColor: Colors.white,
        ),
      ),
    );

    return Theme(
      data: materialTheme,
      child: PlatformProvider(
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true, platformStyle: PlatformStyleData(ios: PlatformStyle.Material)),
        builder: (context) => PlatformApp(
          title: 'SpendSpentSpent',
          home: Material(child: HomeScreen()),
          material: (_, __) => MaterialAppData(theme: materialTheme),
          cupertino: (_, __) => CupertinoAppData(
              theme:
                  CupertinoThemeData(primaryColor: materialTheme.primaryColor)),
        ),
      ),
    );
  }
}
