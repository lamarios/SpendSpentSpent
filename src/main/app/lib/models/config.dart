import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
  bool allowSignup,
      canResetPassword,
      demoMode,
      hasSubscription,
      canConvertCurrency;
  String announcement, convertCurrencyQuota;
  String? minAppVersion;
  int backendVersion;

  Config(
      {required this.demoMode,
      required this.allowSignup,
      required this.announcement,
      required this.canResetPassword,
      required this.hasSubscription,
      this.minAppVersion,
      required this.backendVersion,
      required this.canConvertCurrency,
      required this.convertCurrencyQuota});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
