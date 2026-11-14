import 'package:auto_route/auto_route.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/expense_list.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/state/recurring_expenses.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

@RoutePage()
class RecurringExpenseListTab extends StatelessWidget {
  const RecurringExpenseListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshWhenShown(
      child: ErrorHandler<RecurringExpensesCubit, RecurringExpensesState>(
        child: BlocBuilder<RecurringExpensesCubit, RecurringExpensesState>(
          builder: (context, state) {
            final cubit = context.read<RecurringExpensesCubit>();

            return AnimatedSwitcher(
              duration: panelTransition,
              child: state.loading
                  ? Center(child: LoadingIndicator())
                  : ExpenseList(expenses: state.expenses, refreshExpenses: cubit.getRecurringExpenses),
            );
          },
        ),
      ),
    );
  }
}

/// The tab stays in memory while the server moves the next date of the recurring expenses forward, so the list is
/// refreshed when the tab is shown again and when the app comes back to the foreground.
class RefreshWhenShown extends StatefulWidget {
  final Widget child;

  const RefreshWhenShown({super.key, required this.child});

  @override
  State<RefreshWhenShown> createState() => _RefreshWhenShownState();
}

class _RefreshWhenShownState extends State<RefreshWhenShown> with WidgetsBindingObserver {
  /// The routers from the tabs up to the root, each with the route it shows when the tab is shown. Switching tabs in
  /// the main menu or opening the settings hides the tab as well.
  List<(RoutingController, String)> _routers = const [];

  /// Going back to a page isn't notified by its router, only by the navigation history
  Listenable? _history;
  bool _wasShown = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabsRouter = TabsRouterScope.of(context)?.controller;
    if (tabsRouter != _routers.firstOrNull?.$1) {
      _stopListening();
      final routers = <(RoutingController, String)>[];
      RoutingController? router = tabsRouter;
      var route = RecurringExpenseListRoute.name;
      while (router != null) {
        routers.add((router, route));
        route = router.routeData.name;
        router = router.parent();
      }
      _routers = routers;
      _history = tabsRouter?.root.navigationHistory;
      for (final (router, _) in _routers) {
        router.addListener(_routeChanged);
      }
      _history?.addListener(_routeChanged);
      // the tab is built when it's first shown, the cubit loads the list then
      _wasShown = _isShown;
    }
  }

  @override
  void dispose() {
    _stopListening();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _stopListening() {
    for (final (router, _) in _routers) {
      router.removeListener(_routeChanged);
    }
    _history?.removeListener(_routeChanged);
  }

  bool get _isShown => _routers.every((r) => r.$1.current.name == r.$2);

  void _routeChanged() {
    final shown = _isShown;
    if (shown && !_wasShown) {
      _refresh();
    }
    _wasShown = shown;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isShown) {
      _refresh();
    }
  }

  void _refresh() {
    context.read<RecurringExpensesCubit>().getRecurringExpenses(showLoading: false);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
