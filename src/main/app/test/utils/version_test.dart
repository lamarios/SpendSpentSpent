import 'package:flutter_test/flutter_test.dart';
import 'package:spend_spent_spent/utils/version.dart';

void main() {
  test('parses x.y.z versions and ignores suffixes', () {
    expect(Version.tryParse('2.14.0'), const Version(2, 14, 0));
    expect(Version.tryParse('2.14.0-SNAPSHOT'), const Version(2, 14, 0));
    expect(Version.tryParse('2.14.0+148'), const Version(2, 14, 0));
    expect(Version.tryParse(' 10.0.3 '), const Version(10, 0, 3));
  });

  test('rejects legacy integer versions and garbage', () {
    expect(Version.tryParse('148'), isNull);
    expect(Version.tryParse('2.14'), isNull);
    expect(Version.tryParse('abc'), isNull);
    expect(Version.tryParse(''), isNull);
    expect(Version.tryParse(null), isNull);
  });

  test('compares numerically', () {
    const min = Version(2, 14, 0);

    expect(const Version(2, 14, 0).isAtLeast(min), isTrue);
    expect(const Version(2, 14, 1).isAtLeast(min), isTrue);
    expect(const Version(2, 15, 0).isAtLeast(min), isTrue);
    expect(const Version(3, 0, 0).isAtLeast(min), isTrue);
    expect(const Version(2, 100, 0).isAtLeast(min), isTrue);

    expect(const Version(2, 13, 9).isAtLeast(min), isFalse);
    expect(const Version(1, 99, 99).isAtLeast(min), isFalse);
  });

  test('toString', () {
    expect(const Version(2, 14, 0).toString(), '2.14.0');
  });
}
