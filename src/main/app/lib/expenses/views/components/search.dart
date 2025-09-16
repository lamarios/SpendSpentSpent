import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spend_spent_spent/expenses/models/search_parameters.dart';
import 'package:spend_spent_spent/expenses/state/search.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

final _searchFormat = DateFormat.yMMMd();

class Search extends StatelessWidget {
  final Function(SearchParameters params) search;
  final double iconWidth = 30;

  const Search({super.key, required this.search});

  Future<void> _setDates(BuildContext context) async {
    final cubit = context.read<SearchCubit>();
    final dates = await showDateRangePicker(
      context: context,
      saveText: 'Search',
      firstDate: DateTime.fromMillisecondsSinceEpoch(
        cubit.state.searchParametersBounds.minDate ?? 0,
      ),
      lastDate: DateTime.fromMillisecondsSinceEpoch(
        cubit.state.searchParametersBounds.maxDate ?? 0,
      ),
      initialDateRange: DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
          cubit.state.searchParameters.minDate ?? 0,
        ),
        end: DateTime.fromMillisecondsSinceEpoch(
          cubit.state.searchParameters.maxDate ?? 0,
        ),
      ),
      currentDate: DateTime.now(),
    );

    cubit.setDates(dates);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => SearchCubit(const SearchState(), search),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = context.read<SearchCubit>();

          final from = DateTime.fromMillisecondsSinceEpoch(
            state.searchParameters.minDate ??
                state.searchParametersBounds.minDate ??
                DateTime.now().add(Duration(days: -1)).millisecondsSinceEpoch,
          );
          final to = DateTime.fromMillisecondsSinceEpoch(
            state.searchParameters.maxDate ??
                state.searchParametersBounds.maxDate ??
                DateTime.now().millisecondsSinceEpoch,
          );

          var lightBackground = getLightBackground(context);
          return Container(
            decoration: BoxDecoration(
              color: lightBackground,
              borderRadius: BorderRadius.circular(bigItemBorderRadius),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AnimatedCrossFade(
                        duration: panelTransition,
                        crossFadeState:
                            state.searchParametersBounds.categories.isEmpty
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Center(child: LoadingIndicator()),
                        secondChild: SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.searchParametersBounds.categories
                                .map((c) {
                                  var isSelected =
                                      state
                                              .searchParameters
                                              .categories
                                              .length ==
                                          1 &&
                                      state.searchParameters.categories[0].id ==
                                          c.id;
                                  return Center(
                                    key: ValueKey(c),
                                    child: GestureDetector(
                                      onTap: () => cubit.selectCategory(c),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4.0,
                                        ),
                                        child: AnimatedContainer(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? colors.primaryContainer
                                                : lightBackground,
                                          ),
                                          duration: panelTransition,
                                          child: Center(
                                            child: getIcon(
                                              c.icon ?? "",
                                              color: isSelected
                                                  ? colors.onPrimaryContainer
                                                  : colors.onSurface,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: iconWidth,
                      child: Icon(Icons.attach_money, color: colors.onSurface),
                    ),
                    Expanded(
                      child: RangeSlider(
                        activeColor: colors.primaryContainer,
                        values: RangeValues(
                          state.searchParameters.minAmount.toDouble(),
                          state.searchParameters.maxAmount.toDouble(),
                        ),
                        onChanged: cubit.updateRange,
                        divisions: state.searchParametersBounds.maxAmount > 0
                            ? state.searchParametersBounds.maxAmount -
                                  state.searchParametersBounds.minAmount
                            : null,
                        max: state.searchParametersBounds.maxAmount.toDouble(),
                        min: state.searchParametersBounds.minAmount.toDouble(),
                        labels: RangeLabels(
                          state.searchParameters.minAmount.toString(),
                          state.searchParameters.maxAmount.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 4,
                  children: [
                    SizedBox(
                      width: iconWidth,
                      child: Icon(Icons.search, color: colors.onSurface),
                    ),
                    Expanded(
                      child: TextField(
                        controller: cubit.noteController,
                        autocorrect: false,
                        decoration: const InputDecoration(hintText: "Search"),
                      ),
                    ),
                  ],
                ),
                Gap(8),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => _setDates(context),
                        label: Text(
                          '${_searchFormat.format(from)} - ${_searchFormat.format(to)}',
                        ),
                        icon: Icon(Icons.calendar_month),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () async {
                        final file = await cubit.downloadData();
                        if (context.mounted) {
                          var formatter = DateFormat('yyyy-MM-dd');
                          String fileName =
                              '${formatter.format(DateTime.fromMillisecondsSinceEpoch(state.searchParameters.minDate ?? 0))}_${formatter.format(DateTime.fromMillisecondsSinceEpoch(state.searchParameters.maxDate ?? 0))}.csv';

                          final params = ShareParams(
                            fileNameOverrides: [fileName],
                            files: [
                              XFile.fromData(
                                file,
                                mimeType: "text/csv",
                                name: fileName,
                              ),
                            ],
                          );
                          await SharePlus.instance.share(params);
                        }
                      },
                      icon: Icon(Icons.save_alt),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
