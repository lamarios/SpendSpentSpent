import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

part 'app_settings.freezed.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    final materialYou = Preferences.getBool(MATERIAL_YOU, false);
    final blackBackground = Preferences.getBool(BLACK_BACKGROUND, false);
    final useHouseholdColors = Preferences.getBool(USE_HOUSEFOLD_COLOR, false);
    emit(
      state.copyWith(
        blackBackground: await blackBackground,
        materialYou: await materialYou,
        useHouseholdColors: await useHouseholdColors,
      ),
    );
    service.getCurrentServerConfig();
  }

  Future<void> setMaterialYou(bool value) async {
    await Preferences.setBool(MATERIAL_YOU, value);
    emit(state.copyWith(materialYou: value));
  }

  Future<void> setBlackBackground(bool value) async {
    await Preferences.setBool(BLACK_BACKGROUND, value);
    emit(state.copyWith(blackBackground: value));
  }

  Future<void> setUseHouseholdColos(bool value) async {
    await Preferences.setBool(USE_HOUSEFOLD_COLOR, value);
    emit(state.copyWith(useHouseholdColors: value));
  }
}

@freezed
sealed class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    @Default(false) bool materialYou,
    @Default(false) bool blackBackground,
    @Default(false) bool useHouseholdColors,
    @Default(false) bool watchNotifications,
  }) = _AppSettingsState;
}
