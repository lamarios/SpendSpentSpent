import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/stats/state/stats_list.dart';
import 'package:spend_spent_spent/stats/views/components/single_stat.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/dummyStatsList.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';

@RoutePage()
class LeftColumnTab extends StatelessWidget {
  const LeftColumnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsListCubit(const StatsListState()),
      child: ErrorHandler<StatsListCubit, StatsListState>(
        child: BlocBuilder<StatsListCubit, StatsListState>(
            builder: (context, state) {
          final cubit = context.read<StatsListCubit>();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                  child: Switcher(
                    selected: state.selected,
                    labels: const ['Monthly', 'Yearly'],
                    onSelect: cubit.switchTab,
                  ),
                ),
                Expanded(
                    child: AnimatedSwitcher(
                        duration: panelTransition,
                        child: state.loading
                            ? const DummyStatsList()
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: state.stats.length,
                                itemBuilder: (context, index) {
                                  return SingleStats(
                                    key: Key(state.stats[index].category.id
                                        .toString()),
                                    stats: state.stats[index],
                                    monthly: state.selected == 0,
                                  );
                                },
                              )))
              ],
            ),
          );
        }),
      ),
    );
  }
}
