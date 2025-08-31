import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/expenses/models/search_parameters.dart';
import 'package:spend_spent_spent/expenses/state/search.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';

class Search extends StatelessWidget {
  final Function(SearchParameters params) search;
  final double iconWidth = 30;

  const Search({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => SearchCubit(const SearchState(), search),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = context.read<SearchCubit>();

          return Column(
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
                      secondChild: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: state.searchParametersBounds.categories.map(
                            (c) {
                              var isSelected =
                                  state.searchParameters.categories.length ==
                                      1 &&
                                  state.searchParameters.categories[0].id ==
                                      c.id;
                              return GestureDetector(
                                onTap: () => cubit.selectCategory(c),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: AnimatedContainer(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      color: isSelected
                                          ? colors.primaryContainer
                                          : colors.surface,
                                    ),
                                    duration: panelTransition,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
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
                              );
                            },
                          ).toList(),
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
            ],
          );
        },
      ),
    );
  }
}
