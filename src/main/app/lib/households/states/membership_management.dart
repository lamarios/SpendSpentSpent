import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/households/models/household_enums.dart';

part 'membership_management.freezed.dart';

class MembershipManagementCubit extends Cubit<MembershipManagementState> {
  MembershipManagementCubit(super.initialState);

  void setAdmin(bool admin) {
    emit(state.copyWith(admin: admin));
  }

  void setColor(HouseholdColor color) {
    emit(state.copyWith(color: color));
  }
}

@freezed
sealed class MembershipManagementState with _$MembershipManagementState {
  const factory MembershipManagementState({
    required bool admin,
    required HouseholdColor color,
  }) = _MembershipManagementState;
}
