import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/settings/models/user.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'category.freezed.dart';

part 'category.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.

@freezed
sealed class Category with _$Category {
  const factory Category({
    String? icon,
    int? categoryOrder,
    int? id,
    double? percentageOfMonthly,
    User? user,
  }) = _Category;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
