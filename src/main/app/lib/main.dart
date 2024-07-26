import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/home/views/screens/home.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

final _appRouter = AppRouter();

void main() {
  runApp(SpendSpentSpent());
}

class SpendSpentSpent extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
    );
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );

    const navigationBarTheme = NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide);

    const appBarTheme =
        AppBarTheme(scrolledUnderElevation: 0, color: Colors.transparent);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesCubit(const CategoriesState()),
        ),
        BlocProvider(
          create: (context) => LastExpenseCubit(null),
        )
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        theme: ThemeData(
            navigationBarTheme: navigationBarTheme,
            useMaterial3: true,
            colorScheme: lightColorScheme,
            appBarTheme: appBarTheme),
        darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            navigationBarTheme: navigationBarTheme,
            appBarTheme: appBarTheme),
      ),
    );
  }
}
