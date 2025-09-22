import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/households/states/household_management.dart';
import 'package:spend_spent_spent/households/views/components/member_management.dart';
import 'package:spend_spent_spent/users/views/components/user_profile_icon.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

import '../../models/household.dart';
import '../../models/household_enums.dart';

class HouseholdView extends StatelessWidget {
  final Household household;

  const HouseholdView({super.key, required this.household});

  Future<void> showInviteDialog(BuildContext context) async {
    var textEditingController = TextEditingController();
    showPromptDialog(
      context,
      'Invite user',
      'User email',
      textEditingController,
      () async {
        await context.read<HouseholdManagementCubit>().inviteUser(
          textEditingController.text,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('User invited')));
        }
      },
      maxLines: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final cubit = context.read<HouseholdManagementCubit>();

    final isAdmin = cubit.isAdmin;

    List<HouseholdColor> useColors = household.members
        .map((hm) => hm.color)
        .toList();

    var members = List.of(household.members);
    members.sort((a, b) {
      if (cubit.isSelf(a)) {
        return -1;
      }

      if (cubit.isSelf(b)) {
        return 1;
      }

      return a.user.firstName.compareTo(b.user.firstName);
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: household.members.length,
            itemBuilder: (context, index) {
              var hm = members[index];
              return ListTile(
                leading: UserProfileIcon(
                  user: hm.user,
                  size: 40,
                  colorScheme: hm.color.getColor(context),
                ),
                title: Text('${hm.user.firstName} ${hm.user.lastName}'),
                subtitle: Text(hm.user.email),
                trailing: hm.admin
                    ? Chip(
                        labelStyle: TextStyle(
                          color: colors.onSecondaryContainer,
                        ),
                        label: Text('Admin'),
                        avatar: Icon(
                          Icons.admin_panel_settings_outlined,
                          color: colors.onSecondaryContainer,
                        ),
                        backgroundColor: colors.secondaryContainer,
                      )
                    : null,
                onTap: cubit.isSelf(hm) || isAdmin
                    ? () => MemberManagement.showSheet(
                        context,
                        membership: hm,
                        setAdmin: (membership, admin) =>
                            cubit.setAdmin(membership, admin),
                        isAdmin: isAdmin,
                        isSelf: cubit.isSelf(hm),
                        usedColors: useColors,
                        removeFromHousehold: cubit.removeFromHousehold,
                        setColor: cubit.setColor,
                      )
                    : null,
              );
            },
          ),
        ),
        FilledButton.tonalIcon(
          onPressed: () => showInviteDialog(context),
          label: Text('Invite user to household'),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
