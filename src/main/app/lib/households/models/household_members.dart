import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/households/models/household_enums.dart';
import 'package:spend_spent_spent/settings/models/user.dart';

part 'household_members.freezed.dart';

part 'household_members.g.dart';

@freezed
sealed class HouseholdMembers with _$HouseholdMembers {
  const factory HouseholdMembers({
    required String id,
    required User user,
    User? invitedBy,
    required HouseholdInviteStatus status,
    required HouseholdColor color,
    @Default(false) bool admin,
  }) = _HouseholdMembers;

  factory HouseholdMembers.fromJson(Map<String, Object?> json) => _$HouseholdMembersFromJson(json);
}
