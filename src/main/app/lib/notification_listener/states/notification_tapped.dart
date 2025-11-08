import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_tapped.freezed.dart';

part 'notification_tapped.g.dart';

class NotificationTappedCubit extends Cubit<NotificationTappedState?> {
  NotificationTappedCubit(super.initialState);

  void setTapped(double amount) {
    emit(
      NotificationTappedState(
        amount: amount,
        time: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@freezed
sealed class NotificationTappedState with _$NotificationTappedState {
  const factory NotificationTappedState({
    required int time,
    required double amount,
  }) = _NotificationTappedState;

  factory NotificationTappedState.fromJson(Map<String, Object?> json) =>
      _$NotificationTappedStateFromJson(json);
}
