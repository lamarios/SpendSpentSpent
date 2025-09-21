import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/models/household_enums.dart';
import 'package:spend_spent_spent/households/models/household_members.dart';
import 'package:spend_spent_spent/households/services/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

import '../models/household.dart';

part 'household_management.freezed.dart';

class HouseholdManagementCubit extends Cubit<HouseholdManagementState> {
  HouseholdManagementCubit(super.initialState) {
    getData(true);
  }

  Future<void> getData(bool loading) async {
    try {
      emit(state.copyWith(loading: loading));
      var household = service.getHousehold();
      var invitations = service.getInvitations();

      emit(
        state.copyWith(
          invitations: await invitations,
          household: await household,
        ),
      );
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> createHousehold() async {
    emit(state.copyWith(loading: true));
    try {
      final hs = await service.createHousehold();
      emit(state.copyWith(household: hs));
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> inviteUser(String email) async {
    await service.inviteUser(email);
  }

  bool get isAdmin {
    var user = getIt<UsernamePasswordCubit>().currentUser;
    return state.household?.members
            .where((hm) => hm.user.id == user?.id)
            .map((e) => e.admin)
            .firstOrNull ??
        false;
  }

  bool isSelf(HouseholdMembers membership) {
    var user = getIt<UsernamePasswordCubit>().currentUser;
    return membership.user.id == user?.id;
  }

  Future<void> setAdmin(HouseholdMembers membership, bool value) async {
    try {
      await service.setMemberAdmin(userId: membership.user.id!, isAdmin: value);
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    }
    getData(false);
  }

  Future<void> setColor(
    HouseholdMembers membership,
    HouseholdColor color,
  ) async {
    try {
      await service.setColor(color);
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    }
    getData(false);
  }

  Future<void> removeFromHousehold(HouseholdMembers membership) async {
    try {
      await service.removeUserFromHousehold(membership.user.id!);
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    }

    getData(false);
  }
}

@freezed
sealed class HouseholdManagementState
    with _$HouseholdManagementState
    implements WithError {
  @Implements<WithError>()
  const factory HouseholdManagementState({
    Household? household,
    @Default([]) List<HouseholdMembers> invitations,
    @Default(false) bool loading,
    dynamic error,
    StackTrace? stackTrace,
  }) = _HouseholdManagementState;
}
