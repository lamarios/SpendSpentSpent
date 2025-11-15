import 'package:freezed_annotation/freezed_annotation.dart';

import 'household_members.dart';

part 'household.freezed.dart';

part 'household.g.dart';

@freezed
sealed class Household with _$Household {
  const factory Household({required String id, @Default([]) List<HouseholdMembers> members}) = _Household;

  factory Household.fromJson(Map<String, Object?> json) => _$HouseholdFromJson(json);
}
