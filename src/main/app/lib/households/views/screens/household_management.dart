import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/services/household.dart';
import 'package:spend_spent_spent/households/states/household_management.dart';
import 'package:spend_spent_spent/households/views/components/household.dart';
import 'package:spend_spent_spent/households/views/components/household_invitations.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/models/socket_message.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';
import 'package:spend_spent_spent/utils/views/components/sss_socket_listener.dart';

import '../../states/household.dart';

@RoutePage()
class HouseholdManagementScreen extends StatelessWidget {
  const HouseholdManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => HouseholdManagementCubit(HouseholdManagementState()),
      child: BlocBuilder<HouseholdManagementCubit, HouseholdManagementState>(
        builder: (context, state) {
          final cubit = context.read<HouseholdManagementCubit>();
          return SssSocketListener(
            onChange: (message) {
              if (message.type == SssSocketMessageType.householdUpdate) {
                print('receive message to update household');
                cubit.getData(false);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Household'),
                actions: [
                  if (state.household != null)
                    MenuAnchor(
                      builder: (context, controller, child) {
                        return IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          leadingIcon: Icon(Icons.logout),
                          onPressed: () => okCancelDialog(
                            context,
                            title: 'Leave household ?',
                            content: Text(
                              'After leaving the household, you will not be able to see the other users expenses',
                            ),
                            onOk: () async {
                              await service.leaveHousehold();
                              if (context.mounted) {
                                cubit.getData(true);
                                getIt<HouseholdCubit>().getData();
                              }
                            },
                          ),
                          child: Text('Leave household'),
                        ),
                        if (cubit.isAdmin)
                          MenuItemButton(
                            leadingIcon: Icon(Icons.delete_outline, color: colors.error),
                            onPressed: () => okCancelDialog(
                              context,
                              title: 'Delete household ?',
                              content: Text(
                                'After deleting the household, every member will stop seeing anyone expenses',
                              ),
                              onOk: () async {
                                await service.deleteHousehold();
                                if (context.mounted) {
                                  cubit.getData(true);
                                  getIt<HouseholdCubit>().getData();
                                }
                              },
                            ),
                            child: Text('Delete household', style: TextStyle(color: colors.error)),
                          ),
                      ],
                    ),
                ],
              ),
              body: SafeArea(
                child: ErrorHandler<HouseholdManagementCubit, HouseholdManagementState>(
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
                      : HouseholdInvitations(invitations: state.invitations),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
