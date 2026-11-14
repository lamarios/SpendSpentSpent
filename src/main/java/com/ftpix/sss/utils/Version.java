package com.ftpix.sss.utils;

import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Minimal x.y.z version used for the app/backend compatibility check. Any pre-release or build
 * suffix (e.g. 2.14.0-SNAPSHOT, 2.14.0+12) is ignored when comparing.
 */
public record Version(int major, int minor, int patch) implements Comparable<Version> {

  private static final Pattern PATTERN = Pattern.compile("^(\\d+)\\.(\\d+)\\.(\\d+)(?:[-+].*)?$");

  /**
   * @return the parsed version, or empty if the string isn't an x.y.z version (like the integer
   *     build numbers sent by older apps)
   */
  public static Optional<Version> parse(String version) {
    if (version == null) {
      return Optional.empty();
    }
    Matcher matcher = PATTERN.matcher(version.trim());
    if (!matcher.matches()) {
      return Optional.empty();
    }
    try {
      return Optional.of(
          new Version(
              Integer.parseInt(matcher.group(1)),
              Integer.parseInt(matcher.group(2)),
              Integer.parseInt(matcher.group(3))));
    } catch (NumberFormatException e) {
      return Optional.empty();
    }
  }

  public boolean isAtLeast(Version other) {
    return compareTo(other) >= 0;
  }

  @Override
  public int compareTo(Version o) {
    if (major != o.major) {
      return Integer.compare(major, o.major);
    }
    if (minor != o.minor) {
      return Integer.compare(minor, o.minor);
    }
    return Integer.compare(patch, o.patch);
  }

  @Override
  public String toString() {
    return major + "." + minor + "." + patch;
  }
}
