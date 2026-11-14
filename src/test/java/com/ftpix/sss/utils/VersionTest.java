package com.ftpix.sss.utils;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Optional;
import org.junit.jupiter.api.Test;

public class VersionTest {

  @Test
  public void testParse() {
    assertEquals(Optional.of(new Version(2, 14, 0)), Version.parse("2.14.0"));
    assertEquals(Optional.of(new Version(2, 14, 0)), Version.parse("2.14.0-SNAPSHOT"));
    assertEquals(Optional.of(new Version(2, 14, 0)), Version.parse("2.14.0+148"));
    assertEquals(Optional.of(new Version(10, 0, 3)), Version.parse(" 10.0.3 "));

    // legacy integer build numbers and garbage aren't versions
    assertTrue(Version.parse("148").isEmpty());
    assertTrue(Version.parse("2.14").isEmpty());
    assertTrue(Version.parse("abc").isEmpty());
    assertTrue(Version.parse("").isEmpty());
    assertTrue(Version.parse(null).isEmpty());
  }

  @Test
  public void testCompare() {
    Version min = new Version(2, 14, 0);

    assertTrue(new Version(2, 14, 0).isAtLeast(min));
    assertTrue(new Version(2, 14, 1).isAtLeast(min));
    assertTrue(new Version(2, 15, 0).isAtLeast(min));
    assertTrue(new Version(3, 0, 0).isAtLeast(min));
    // numeric, not lexicographic
    assertTrue(new Version(2, 100, 0).isAtLeast(min));

    assertFalse(new Version(2, 13, 9).isAtLeast(min));
    assertFalse(new Version(1, 99, 99).isAtLeast(min));
  }

  @Test
  public void testToString() {
    assertEquals("2.14.0", new Version(2, 14, 0).toString());
  }
}
