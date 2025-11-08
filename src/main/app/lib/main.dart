import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/notification_listener/notification_event_listener.dart';
import 'package:spend_spent_spent/notification_listener/states/notification_tapped.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

import 'globals.dart';

final _appRouter = AppRouter();

final _log = Logger('Main');

Future<void> main() async {
  Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  // set up standard user creds
  var existingToken = await Preferences.get(Preferences.TOKEN);

  var userPassCubit = UsernamePasswordCubit(
    UsernamePasswordState(
      token: existingToken.isNotEmpty ? existingToken : null,
    ),
  );

  var householdCubit = HouseholdCubit(HouseholdState());
  getIt.registerSingleton<HouseholdCubit>(householdCubit);

  getIt.registerSingleton<UsernamePasswordCubit>(userPassCubit);
  // we check if we already are on  a server
  var serverUrl = await Preferences.get(Preferences.SERVER_URL);
  if (serverUrl.isNotEmpty) {
    try {
      await service.setUrl(serverUrl);
    } catch (e) {
      await Preferences.remove(Preferences.SERVER_URL);
    }
  }

  // once we're all ready, and we're already logged in, we connect to the websocket
  if (existingToken.isNotEmpty) {
    userPassCubit.connectToSocket();
    householdCubit.getData();
  }

  getIt.registerSingleton<NotificationTappedCubit>(
    NotificationTappedCubit(null),
  );
  var notificationEventListener = NotificationEventListener();
  getIt.registerSingleton<NotificationEventListener>(notificationEventListener);
  if (!kIsWeb && await Preferences.getBool(WATCH_NOTIFICATIONS)) {
    notificationEventListener.init();
  }

  runApp(const SpendSpentSpent());
}

class SpendSpentSpent extends StatefulWidget {
  const SpendSpentSpent({super.key});

  @override
  State<SpendSpentSpent> createState() => _SpendSpentSpentState();
}

class _SpendSpentSpentState extends State<SpendSpentSpent>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    getIt<UsernamePasswordCubit>().socket?.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _log.fine('app state: $state');
    if (state == AppLifecycleState.hidden) {
      _log.info("App is hiding, disconnecting from websocket");
      getIt<UsernamePasswordCubit>().socket?.close();
    } else if (state == AppLifecycleState.resumed) {
      getIt<UsernamePasswordCubit>().socket?.connect();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesCubit(const CategoriesState()),
        ),
        BlocProvider(create: (context) => LastExpenseCubit(0)),
        BlocProvider(
          create: (context) => AppSettingsCubit(const AppSettingsState()),
        ),
        BlocProvider(create: (context) => getIt<UsernamePasswordCubit>()),
        BlocProvider(create: (context) => getIt<HouseholdCubit>()),
        BlocProvider(create: (context) => getIt<NotificationTappedCubit>()),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return BlocBuilder<AppSettingsCubit, AppSettingsState>(
            builder: (context, state) {
              ColorScheme lightColorScheme;
              ColorScheme darkColorScheme;

              final householdCubit = context.watch<HouseholdCubit>();

              if (state.materialYou &&
                  lightDynamic != null &&
                  darkDynamic != null) {
                lightColorScheme = lightDynamic;
                darkColorScheme = darkDynamic;
              } else {
                lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                );
              }

              if (state.useHouseholdColors) {
                final currentUser = context
                    .read<UsernamePasswordCubit>()
                    .currentUser;
                if (householdCubit.state.household != null &&
                    currentUser != null) {
                  lightColorScheme =
                      householdCubit.state.userLightColors[currentUser.id!] ??
                      lightColorScheme;
                  darkColorScheme =
                      householdCubit.state.userDarkColors[currentUser.id!] ??
                      darkColorScheme;
                }
              }

              if (state.blackBackground) {
                darkColorScheme = darkColorScheme.copyWith(
                  surface: Colors.black,
                );
              }

              const navigationBarTheme = NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              );

              const appBarTheme = AppBarTheme(
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
              );

              return MaterialApp.router(
                routerConfig: _appRouter.config(),
                localizationsDelegates: [],
                theme: ThemeData(
                  scaffoldBackgroundColor: lightColorScheme.surface,
                  navigationBarTheme: navigationBarTheme.copyWith(
                    backgroundColor: lightColorScheme.surface,
                  ),
                  useMaterial3: true,
                  colorScheme: lightColorScheme,
                  appBarTheme: appBarTheme.copyWith(
                    backgroundColor: lightColorScheme.surface,
                  ),
                ),
                darkTheme: ThemeData(
                  scaffoldBackgroundColor: darkColorScheme.surface,
                  useMaterial3: true,
                  colorScheme: darkColorScheme,
                  navigationBarTheme: navigationBarTheme.copyWith(
                    backgroundColor: darkColorScheme.surface,
                  ),
                  appBarTheme: appBarTheme.copyWith(
                    backgroundColor: darkColorScheme.surface,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
