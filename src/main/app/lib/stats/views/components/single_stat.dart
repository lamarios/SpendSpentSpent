import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';
import 'package:spend_spent_spent/stats/models/left_column_stats.dart';
import 'package:spend_spent_spent/stats/state/single_stats.dart';
import 'package:spend_spent_spent/stats/views/components/stats_graph.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class SingleStats extends StatelessWidget {
  final LeftColumnStats stats;
  final bool monthly;
  final double openedHeight = 400;

  const SingleStats({super.key, required this.monthly, required this.stats});

  double getBarWidth(BuildContext context, BoxConstraints constraints) {
    final cubit = context.read<SingleStatsCubit>();

    final percentage = stats.amount / stats.total;

    if (cubit.state.open) {
      return constraints.maxWidth;
    } else if (stats.total > 0) {
      return constraints.maxWidth * percentage;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // TODO: implement build
    return BlocProvider(
      create: (context) => SingleStatsCubit(const SingleStatsState()),
      child: BlocConsumer<SingleStatsCubit, SingleStatsState>(
        listener: (BuildContext context, SingleStatsState state) {
          Scrollable.ensureVisible(
            context,
            curve: Curves.easeInOutQuint,
            duration: panelTransition * 2,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        },
        listenWhen: (previous, current) =>
            previous.showGraph != current.showGraph,
        builder: (context, state) {
          final cubit = context.read<SingleStatsCubit>();

          final openedBackgroundColor = getLightBackground(context);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: cubit.openContainer,
              behavior: HitTestBehavior.translucent,
              child: Column(
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      AnimatedRotation(
                        turns: state.open ? 0.25 : 0,
                        duration: panelTransition,
                        curve: Curves.easeInOutQuint,
                        child: Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: colors.onSurface,
                        ),
                      ),
                      Visibility(
                        visible: stats.category.id != -1,
                        child: getIcon(
                          stats.category.icon!,
                          color: colors.primary,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Text(formatCurrency(stats.amount)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: AnimatedContainer(
                      duration: panelTransition,
                      curve: Curves.easeInOutQuint,
                      alignment: Alignment.topLeft,
                      height: state.open ? openedHeight : 10,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        // gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                        color: state.open
                            ? colors.surface
                            : colors.primaryContainer,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) => AnimatedContainer(
                          duration: panelTransition,
                          curve: Curves.easeInOutQuint,
                          width: getBarWidth(context, constraints),
                          height: state.open ? openedHeight : 10,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: state.open
                                ? openedBackgroundColor
                                : colors.onPrimaryContainer,
                          ),
                          child: Visibility(
                            visible: state.showGraph,
                            child: FadeIn(
                              duration: panelTransition,
                              child: StatsGraph(
                                categoryId: stats.category.id!,
                                monthly: monthly,
                                close: cubit.closeContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
