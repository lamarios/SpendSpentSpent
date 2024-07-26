import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/categories/state/add_category.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/categories/views/components/add_category_dialog/categories.dart';

class AddCategory extends StatelessWidget {
  final Function(String selected) onSelected;
  final String? buttonLabel;

  const AddCategory({super.key, required this.onSelected, this.buttonLabel});

  void onSelect(BuildContext context, String s) {
    FocusManager.instance.primaryFocus?.unfocus();
    final cubit = context.read<AddCategoryCubit>();
    cubit.setSelected(s);
  }

  addCategory(BuildContext context) async {
    final cubit = context.read<AddCategoryCubit>();
    onSelected(cubit.state.selected);
    Navigator.pop(context);
  }

  closeDialog(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => AddCategoryCubit(
          const AddCategoryState(), context.read<CategoriesCubit>()),
      child: BlocBuilder<AddCategoryCubit, AddCategoryState>(
          builder: (context, state) {
        final cubit = context.read<AddCategoryCubit>();
        return Stack(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: colors.primaryContainer,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: colors.onPrimaryContainer,
                            size: 15,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: cubit.searchController,
                            style:
                                TextStyle(color: colors.onSecondaryContainer),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              filled: true,
                              fillColor: colors.primaryContainer,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: colors.onPrimaryContainer
                                      .withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Categories(
                            label: 'Shopping',
                            categories: state.categories.shopping,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Transports',
                            categories: state.categories.transports,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Brands',
                            categories: state.categories.brands,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Hobbies',
                            categories: state.categories.hobbies,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Health',
                            categories: state.categories.health,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Education',
                            categories: state.categories.education,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Housing',
                            categories: state.categories.housing,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Tech',
                            categories: state.categories.tech,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                          Categories(
                            label: 'Documents',
                            categories: state.categories.documents,
                            onSelect: (selected) => onSelect(context, selected),
                            selected: state.selected,
                          ),
                        ],
                      ),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: FilledButton.tonal(
                          onPressed: state.selected != ''
                              ? () => addCategory(context)
                              : null,
                          child: Text(buttonLabel ?? 'Add category'),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 3,
              child: IconButton(
                  onPressed: () => closeDialog(context),
                  icon: FaIcon(
                    FontAwesomeIcons.xmark,
                    color: colors.onSecondaryContainer,
                    size: 20,
                  )),
            ),
          ],
        );
      }),
    );
  }
}
