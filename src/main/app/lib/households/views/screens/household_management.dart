import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/households/states/household_management.dart';
import 'package:spend_spent_spent/households/views/components/household.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

@RoutePage()
class HouseholdManagementScreen extends StatelessWidget {
  const HouseholdManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Household')),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              HouseholdManagementCubit(HouseholdManagementState()),
          child: BlocBuilder<HouseholdManagementCubit, HouseholdManagementState>(
            builder: (context, state) {
              final cubit = context.read<HouseholdManagementCubit>();

              return ErrorHandler<
                HouseholdManagementCubit,
                HouseholdManagementState
              >(
                child: state.loading
                    ? Center(child: LoadingIndicator())
                    : (state.household == null && state.invitations.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16,
                          children: [
                            Icon(Icons.add_home_outlined, size: 70),
                            Text(
                              'A household lets you share expenses with family, roommates, or anyone you live with. All members can view each other’s expenses, and you can manage membership at any time. Keep in mind that once you add someone, they will have full visibility of all expenses in the household.',
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                okCancelDialog(
                                  context,
                                  title: 'Adding household',
                                  content: Text(
                                    'Keep in mind that once you add someone, they will have full visibility of all expenses in the household',
                                  ),
                                  onOk: () => cubit.createHousehold(),
                                );
                              },
                              label: Text('Create household'),
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      )
                    : state.household != null
                    ? HouseholdView(household: state.household!)
                    : Text('invitations'),
              );
            },
          ),
        ),
      ),
    );
  }
}
