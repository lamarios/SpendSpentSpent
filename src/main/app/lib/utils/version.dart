/// Minimal x.y.z version used for the app/backend compatibility check.
/// Any pre-release or build suffix (e.g. 2.14.0-SNAPSHOT, 2.14.0+12) is ignored when comparing.
class Version implements Comparable<Version> {
  static final _pattern = RegExp(r'^(\d+)\.(\d+)\.(\d+)(?:[-+].*)?$');

  final int major, minor, patch;

  const Version(this.major, this.minor, this.patch);

  /// Returns null if [version] isn't an x.y.z version, like the integer build numbers sent by older backends.
  static Version? tryParse(String? version) {
    if (version == null) return null;
    final match = _pattern.firstMatch(version.trim());
    if (match == null) return null;
    final parts = [1, 2, 3].map((i) => int.tryParse(match.group(i)!)).toList();
    if (parts.contains(null)) return null;
    return Version(parts[0]!, parts[1]!, parts[2]!);
  }

  bool isAtLeast(Version other) => compareTo(other) >= 0;

  @override
  int compareTo(Version other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  @override
  bool operator ==(Object other) =>
      other is Version && other.major == major && other.minor == minor && other.patch == patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}
