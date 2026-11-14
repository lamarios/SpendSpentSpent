import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/recurring_expenses/state/recurring_expenses.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';

/// With their type arguments, the cubits are looked up by their type.
List<BlocProvider> _providers() => [
  BlocProvider<CategoriesCubit>(create: (context) => getIt.get<CategoriesCubit>()),
  BlocProvider<LastExpenseCubit>(create: (context) => LastExpenseCubit(0)),
  BlocProvider<AppSettingsCubit>(create: (context) => AppSettingsCubit(const AppSettingsState())),
  BlocProvider<UsernamePasswordCubit>(create: (context) => getIt.get<UsernamePasswordCubit>()),
  BlocProvider<HouseholdCubit>(create: (context) => getIt.get<HouseholdCubit>()),
  BlocProvider<RecurringExpensesCubit>(create: (context) => RecurringExpensesCubit(const RecurringExpensesState())),
];

class TestSetup extends StatelessWidget {
  final Widget child;

  const TestSetup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _providers(),
      child: MaterialApp(
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        home: StackRouterScope(
          controller: AppRouter(),
          stateHash: 0,
          child: Scaffold(body: child),
        ),
      ),
    );
  }
}

class DeepLinkTestSetup extends StatelessWidget {
  final PageRouteInfo route;

  const DeepLinkTestSetup({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _providers(),
      child: MaterialApp.router(
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRouter().config(deepLinkBuilder: (deepLink) => DeepLink.single(route)),
      ),
    );
  }
}

class RouterTestSetup extends StatelessWidget {
  final RootStackRouter router;

  const RouterTestSetup({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _providers(),
      child: MaterialApp.router(routerConfig: router.config()),
    );
  }
}
