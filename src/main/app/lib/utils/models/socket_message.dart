import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_message.freezed.dart';
part 'socket_message.g.dart';

enum SssSocketMessageType { sssFile, householdUpdate, newHouseholdExpense }

@freezed
sealed class SssSocketMessage with _$SssSocketMessage {
  const factory SssSocketMessage({required Map<String, dynamic> message, required SssSocketMessageType type}) =
      _SssSocketMessage;

  factory SssSocketMessage.fromJson(Map<String, Object?> json) => _$SssSocketMessageFromJson(json);
}
