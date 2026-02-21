import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';

class TestSetup extends StatelessWidget {
  final Widget child;

  const TestSetup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt.get<CategoriesCubit>()),
        BlocProvider(create: (context) => LastExpenseCubit(0)),
        BlocProvider(create: (context) => AppSettingsCubit(const AppSettingsState())),
        BlocProvider(create: (context) => getIt.get<UsernamePasswordCubit>()),
        BlocProvider(create: (context) => getIt.get<HouseholdCubit>()),
      ],
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
      providers: [
        BlocProvider(create: (context) => getIt.get<CategoriesCubit>()),
        BlocProvider(create: (context) => LastExpenseCubit(0)),
        BlocProvider(create: (context) => AppSettingsCubit(const AppSettingsState())),
        BlocProvider(create: (context) => getIt.get<UsernamePasswordCubit>()),
        BlocProvider(create: (context) => getIt.get<HouseholdCubit>()),
      ],
      child: MaterialApp.router(
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRouter().config(deepLinkBuilder: (deepLink) => DeepLink.single(route)),
      ),
    );
  }
}
