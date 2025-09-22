import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/households/models/household_members.dart';
import 'package:spend_spent_spent/households/states/household_management.dart';
import 'package:spend_spent_spent/users/views/components/user_profile_icon.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class HouseholdInvitations extends StatelessWidget {
  final List<HouseholdMembers> invitations;

  const HouseholdInvitations({super.key, required this.invitations});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${invitations.length} invitations',
            style: textTheme.titleMedium,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invite = invitations[index];
                return ListTile(
                  leading: UserProfileIcon(user: invite.invitedBy!, size: 50),
                  title: Text(
                    'From ${invite.invitedBy?.firstName} ${invite.invitedBy?.lastName}',
                  ),
                  subtitle: Text(invite.invitedBy?.email ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          okCancelDialog(
                            context,
                            title: 'Accept invitation ?',
                            content: Text(
                              'If you accept the invitation, you will see the household expenses and the household members will see your expenses as well',
                            ),
                            onOk: () {
                              context
                                  .read<HouseholdManagementCubit>()
                                  .acceptInvitation(invite.id);
                            },
                          );
                        },
                        icon: Icon(Icons.check, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () {
                          okCancelDialog(
                            context,
                            title: 'Reject invitation ?',
                            content: Text(
                              'You will need to be invited again if you want to join this household',
                            ),
                            onOk: () {
                              context
                                  .read<HouseholdManagementCubit>()
                                  .rejectInvitation(invite.id);
                            },
                          );
                        },
                        icon: Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
