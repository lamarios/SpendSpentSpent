import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/households/models/household_enums.dart';
import 'package:spend_spent_spent/households/models/household_members.dart';
import 'package:spend_spent_spent/households/states/membership_management.dart';
import 'package:spend_spent_spent/households/views/components/member_color.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class MemberManagement extends StatelessWidget {
  final HouseholdMembers membership;
  final List<HouseholdColor> usedColors;
  final bool isAdmin;
  final bool isSelf;
  final Function(HouseholdMembers membership, bool admin) setAdmin;
  final Function(HouseholdMembers membership, HouseholdColor color) setColor;
  final Function(HouseholdMembers membership) removeFromHousehold;

  const MemberManagement({
    super.key,
    required this.membership,
    required this.setAdmin,
    required this.isAdmin,
    required this.isSelf,
    required this.setColor,
    required this.removeFromHousehold,
    required this.usedColors,
  });

  static Future<void> showSheet(
    BuildContext context, {
    required HouseholdMembers membership,

    required bool isAdmin,
    required bool isSelf,
    required List<HouseholdColor> usedColors,
    required Function(HouseholdMembers membership, bool admin) setAdmin,
    required Function(HouseholdMembers membership, HouseholdColor color)
    setColor,
    required Function(HouseholdMembers membership) removeFromHousehold,
  }) async {
    return await showMotorBottomSheet(
      context: context,
      child: Wrap(
        children: [
          MemberManagement(
            membership: membership,
            isAdmin: isAdmin,
            isSelf: isSelf,
            setAdmin: setAdmin,
            usedColors: usedColors,
            setColor: setColor,
            removeFromHousehold: removeFromHousehold,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocProvider(
        create: (context) => MembershipManagementCubit(
          MembershipManagementState(
            admin: membership.admin,
            color: membership.color,
          ),
        ),
        child: BlocBuilder<MembershipManagementCubit, MembershipManagementState>(
          builder: (context, state) {
            var hmColor = state.color.getColor(context);
            final settingsCubit = context.watch<AppSettingsCubit>();
            final useHouseholdColors = settingsCubit.state.useHouseholdColors;

            final cubit = context.read<MembershipManagementCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(24),
                Text(
                  '${membership.user.firstName} ${membership.user.lastName}',
                  style: textTheme.titleMedium,
                ),
                if (isSelf)
                  ListTile(
                    title: Text('Color'),
                    trailing: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        color: hmColor.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () async {
                      final newColor = await MemberColor.showSheet(
                        context,
                        value: state.color,
                        usedColors: usedColors,
                      );
                      if (newColor != null) {
                        cubit.setColor(newColor);
                        setColor(membership, newColor);
                      }
                    },
                  ),
                if (isSelf)
                  SwitchListTile(
                    value: useHouseholdColors,
                    title: Text('Use color to theme the whole application'),
                    onChanged: (value) =>
                        settingsCubit.setUseHouseholdColos(value),
                  ),
                if (isAdmin && !isSelf) ...[
                  SwitchListTile(
                    title: Text('Admin'),
                    value: state.admin,
                    onChanged: (value) {
                      cubit.setAdmin(value);
                      setAdmin(membership, value);
                    },
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      okCancelDialog(
                        context,
                        title: 'Remove from household',
                        content: Text(
                          'By removing this user from the household, they won\;t be able to see the household expense, and the household will not be able to see their expense',
                        ),
                        onOk: () {
                          Navigator.of(context).pop();
                          removeFromHousehold(membership);
                        },
                      );
                    },
                    label: Text('Remove from household'),
                    icon: Icon(
                      Icons.person_off_outlined,
                      color: colors.onErrorContainer,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        colors.errorContainer,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        colors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
