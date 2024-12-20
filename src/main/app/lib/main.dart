import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';

final _appRouter = AppRouter();

void main() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(const SpendSpentSpent());
}

class SpendSpentSpent extends StatelessWidget {
  const SpendSpentSpent({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesCubit(const CategoriesState()),
        ),
        BlocProvider(
          create: (context) => LastExpenseCubit(0),
        ),
        BlocProvider(
          create: (context) => AppSettingsCubit(const AppSettingsState()),
        )
      ],
      child: DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return BlocBuilder<AppSettingsCubit, AppSettingsState>(
            builder: (context, state) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          print('hello ${state.materialYou} ');

          if (state.materialYou &&
              lightDynamic != null &&
              darkDynamic != null) {
            print(' ??? ');
            lightColorScheme = lightDynamic;
            darkColorScheme = darkDynamic;
          } else {
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
            );
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            );
          }

          if (state.blackBackground) {
            darkColorScheme = darkColorScheme.copyWith(surface: Colors.black);
          }

          const navigationBarTheme = NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide);

          const appBarTheme =
              AppBarTheme(scrolledUnderElevation: 0, color: Colors.transparent);

          return MaterialApp.router(
            routerConfig: _appRouter.config(),
            theme: ThemeData(
                scaffoldBackgroundColor: lightColorScheme.surface,
                navigationBarTheme: navigationBarTheme.copyWith(
                    backgroundColor: lightColorScheme.surface),
                useMaterial3: true,
                colorScheme: lightColorScheme,
                appBarTheme: appBarTheme.copyWith(
                    backgroundColor: lightColorScheme.surface)),
            darkTheme: ThemeData(
                scaffoldBackgroundColor: darkColorScheme.surface,
                useMaterial3: true,
                colorScheme: darkColorScheme,
                navigationBarTheme: navigationBarTheme.copyWith(
                    backgroundColor: darkColorScheme.surface),
                appBarTheme: appBarTheme.copyWith(
                    backgroundColor: darkColorScheme.surface)),
          );
        });
      }),
    );
  }
}
