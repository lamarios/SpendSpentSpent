import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';
import 'package:spend_spent_spent/stats/state/stats_list.dart';
import 'package:spend_spent_spent/stats/views/components/single_stat.dart';
import 'package:spend_spent_spent/utils/views/components/data_change_monitor.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

class StatsView extends StatelessWidget {
  final bool monthly;

  const StatsView({super.key, required this.monthly});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatsListCubit(const StatsListState(), monthly: monthly),
      child: DataChangeMonitor(
        onChange: (context) => context.read<StatsListCubit>().getStats(),
        child: ErrorHandler<StatsListCubit, StatsListState>(
          child: BlocBuilder<StatsListCubit, StatsListState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AnimatedSwitcher(
                  duration: panelTransition,
                  child: state.loading
                      ? Center(child: LoadingIndicator())
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.stats.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == state.stats.length - 1
                                    ? bottomPadding
                                    : 0,
                              ),
                              child: SingleStats(
                                key: Key(
                                  state.stats[index].category.id.toString(),
                                ),
                                stats: state.stats[index],
                                monthly: monthly,
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
