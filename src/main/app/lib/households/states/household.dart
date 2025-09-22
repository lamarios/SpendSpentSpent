import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/models/household.dart';
import 'package:spend_spent_spent/households/models/household_members.dart';
import 'package:spend_spent_spent/households/services/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/settings/models/user.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'household.freezed.dart';

class HouseholdCubit extends Cubit<HouseholdState> {
  HouseholdCubit(super.initialState);

  Future<void> getData() async {
    try {
      var household = await service.getHousehold();
      var invitations = await service.getInvitations();

      Map<String, ColorScheme> userLightColors = {};
      Map<String, ColorScheme> userDarkColors = {};

      if (household != null) {
        for (var hm in household.members) {
          if (hm.user.id != null) {
            userLightColors[hm.user.id!] = ColorScheme.fromSeed(
              seedColor: hm.color.color,
            );
            userDarkColors[hm.user.id!] = ColorScheme.fromSeed(
              seedColor: hm.color.color,
              brightness: Brightness.dark,
            );
          }
        }
      }

      emit(
        state.copyWith(
          invitations: invitations,
          household: household,
          userDarkColors: userDarkColors,
          userLightColors: userLightColors,
        ),
      );
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    }
  }
}

@freezed
sealed class HouseholdState with _$HouseholdState implements WithError {
  @Implements<WithError>()
  const factory HouseholdState({
    Household? household,
    @Default([]) List<HouseholdMembers> invitations,
    @Default({}) Map<String, ColorScheme> userLightColors,
    @Default({}) Map<String, ColorScheme> userDarkColors,
    dynamic error,
    StackTrace? stackTrace,
  }) = _HouseholdState;

  const HouseholdState._();

  ColorScheme? getForUser(BuildContext context, User user) {
    if (Theme.brightnessOf(context) == Brightness.dark) {
      return userDarkColors[user.id!];
    } else {
      return userLightColors[user.id];
    }
  }

  ColorScheme getCategoryColor(BuildContext context, Category category) {
    final colors = Theme.of(context).colorScheme;

    final currentUser = context.read<UsernamePasswordCubit>().currentUser;
    return currentUser?.id != null &&
            (category.user == null || currentUser!.id == category.user?.id)
        ? colors
        : context.read<HouseholdCubit>().state.getForUser(
                context,
                category.user!,
              ) ??
              colors;
  }
}
