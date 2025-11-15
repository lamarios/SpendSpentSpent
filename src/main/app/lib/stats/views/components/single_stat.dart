import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/stats/models/left_column_stats.dart';
import 'package:spend_spent_spent/stats/state/single_stats.dart';
import 'package:spend_spent_spent/stats/views/components/stats_graph.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class SingleStats extends StatelessWidget {
  final LeftColumnStats stats;
  final bool monthly;
  final double openedHeight = 400;

  const SingleStats({super.key, required this.monthly, required this.stats});

  Future<void> ensureVisibleWithConditionalOffset(
    BuildContext context, {
    double extraOffset = 0.0,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) return;

    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
    final ScrollableState scrollableState = Scrollable.of(context);
    final ScrollPosition position = scrollableState.position;

    // Compute the offset for "align at bottom"
    final double targetOffset = viewport.getOffsetToReveal(renderObject, 1.0).offset;

    // First let ensureVisible do its thing
    await position.ensureVisible(
      renderObject,
      alignment: 1.0,
      duration: duration,
      curve: curve,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );

    // Now measure again
    final RenderBox box = renderObject as RenderBox;
    final Offset globalOffset = box.localToGlobal(Offset.zero);
    final double widgetBottom = globalOffset.dy + box.size.height;
    final double screenHeight = MediaQuery.of(context).size.height;

    // If widget is hidden behind the bottom bar, scroll just enough
    if (widgetBottom > screenHeight - extraOffset) {
      final double adjustedOffset = (targetOffset + extraOffset).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      await position.animateTo(adjustedOffset, duration: duration, curve: curve);
    }
  }

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

    var householdCubit = context.read<HouseholdCubit>();
    final catColor = stats.category.id != -1 ? householdCubit.state.getCategoryColor(context, stats.category) : colors;

    // TODO: implement build
    return BlocProvider(
      create: (context) => SingleStatsCubit(const SingleStatsState()),
      child: BlocConsumer<SingleStatsCubit, SingleStatsState>(
        listener: (BuildContext context, SingleStatsState state) {
          ensureVisibleWithConditionalOffset(
            context,
            curve: Curves.easeInOutQuint,
            duration: panelTransition * 2,
            extraOffset: 100,
          );
        },
        listenWhen: (previous, current) => previous.showGraph != current.showGraph,
        builder: (context, state) {
          final cubit = context.read<SingleStatsCubit>();

          final openedBackgroundColor = getLightBackground(context, catColor);

          return SingleMotionBuilder(
            motion: MaterialSpringMotion.expressiveSpatialDefault(),
            value: state.open ? 1 : 0,
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                onTap: cubit.openContainer,
                behavior: HitTestBehavior.translucent,
                child: Column(
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        Transform.scale(
                          scale: lerpDouble(1, 1.4, value),
                          alignment: Alignment.center,
                          child: Transform.rotate(
                            angle: lerpDouble(0, math.pi / 2, value)!,
                            child: Icon(Icons.chevron_right, size: 20, color: colors.onSurface),
                          ),
                        ),
                        Visibility(
                          visible: stats.category.id != -1,
                          child: Transform.scale(
                            scale: lerpDouble(1, 1.4, value),
                            alignment: Alignment.centerLeft,
                            child: getIcon(stats.category.icon!, color: catColor.primary, size: 20),
                          ),
                        ),
                        const Spacer(),
                        Transform.scale(
                          scale: lerpDouble(1, 1.4, value),
                          alignment: Alignment.centerRight,
                          child: Text(formatCurrency(stats.amount)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        height: max(0, lerpDouble(10, openedHeight, value)!),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          // gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                          // color: state.open
                          //     ? colors.surface
                          //     : colors.primaryContainer,
                          color: Color.lerp(catColor.primaryContainer, catColor.surface, value),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final percentage = stats.total > 0 ? stats.amount / stats.total : 0;
                            double widthValue = lerpDouble(
                              constraints.maxWidth * percentage,
                              constraints.maxWidth,
                              value,
                            )!;
                            var useGradient =
                                stats.category.id == -1 && (householdCubit.state.household?.members ?? []).length > 1;
                            return Container(
                              width: max(0, widthValue),
                              height: max(0, lerpDouble(10, openedHeight, value)!),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                gradient: useGradient
                                    ? LinearGradient(
                                        colors: householdCubit.state
                                            .colorsAsGradient(context, (colors) => colors.onPrimaryContainer)
                                            .colors
                                            .map((e) => Color.lerp(e, openedBackgroundColor, value) ?? e)
                                            .toList(),
                                      )
                                    : null,
                                color: useGradient
                                    ? null
                                    : Color.lerp(catColor.onPrimaryContainer, openedBackgroundColor, value),
                                // color: state.open
                                //     ? openedBackgroundColor
                                //     : colors.onPrimaryContainer,
                              ),
                              child: Visibility(
                                visible: state.showGraph,
                                child: FadeIn(
                                  duration: panelTransition,
                                  child: StatsGraph(
                                    categoryId: stats.category.id!,
                                    colors: catColor,
                                    monthly: monthly,
                                    close: cubit.closeContainer,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
