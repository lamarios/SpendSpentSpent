package com.ftpix.sss.mcp;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;
import org.junit.jupiter.api.Test;

public class MCPToolsDateParsingTest {

  private static final ZoneId ZONE = ZoneId.of("Europe/Paris");

  private static long millis(int year, int month, int day, int hour, int minute, int second) {
    return millis(year, month, day, hour, minute, second, 0);
  }

  private static long millis(
      int year, int month, int day, int hour, int minute, int second, int nanos) {
    return ZonedDateTime.of(year, month, day, hour, minute, second, nanos, ZONE)
        .toInstant()
        .toEpochMilli();
  }

  @Test
  public void testDateOnlyUsesDefaultTime() {
    assertEquals(
        millis(2024, 3, 15, 0, 0, 0),
        MCPTools.parseToEpochMillis("2024-03-15", ZONE, MCPTools.START_OF_DAY));
    assertEquals(
        millis(2024, 3, 15, 23, 59, 59),
        MCPTools.parseToEpochMillis("2024-03-15", ZONE, MCPTools.END_OF_DAY));
    assertEquals(
        millis(2024, 3, 15, 12, 30, 0),
        MCPTools.parseToEpochMillis("2024-03-15", ZONE, LocalTime.of(12, 30)));
  }

  @Test
  public void testDateOnlyMatchesPreviousBehaviour() {
    LocalDate date = LocalDate.parse("2024-03-15");
    long previousFrom = date.atTime(0, 0, 0).atZone(ZONE).toEpochSecond() * 1000;
    long previousTo = date.atTime(23, 59, 59).atZone(ZONE).toEpochSecond() * 1000;

    assertEquals(
        previousFrom, MCPTools.parseToEpochMillis("2024-03-15", ZONE, MCPTools.START_OF_DAY));
    assertEquals(previousTo, MCPTools.parseToEpochMillis("2024-03-15", ZONE, MCPTools.END_OF_DAY));
  }

  @Test
  public void testDateTimeWithT() {
    assertEquals(
        millis(2024, 3, 15, 8, 45, 10),
        MCPTools.parseToEpochMillis("2024-03-15T08:45:10", ZONE, MCPTools.START_OF_DAY));
    // supplied time wins over the default
    assertEquals(
        millis(2024, 3, 15, 8, 45, 10),
        MCPTools.parseToEpochMillis("2024-03-15T08:45:10", ZONE, MCPTools.END_OF_DAY));
  }

  @Test
  public void testDateTimeWithSpace() {
    assertEquals(
        millis(2024, 3, 15, 17, 5, 0),
        MCPTools.parseToEpochMillis("2024-03-15 17:05:00", ZONE, MCPTools.END_OF_DAY));
  }

  @Test
  public void testFractionalSeconds() {
    assertEquals(
        millis(2024, 3, 15, 17, 5, 1, 250_000_000),
        MCPTools.parseToEpochMillis("2024-03-15T17:05:01.25", ZONE, MCPTools.START_OF_DAY));
    assertEquals(
        millis(2024, 3, 15, 17, 5, 1, 123_000_000),
        MCPTools.parseToEpochMillis("2024-03-15 17:05:01.123", ZONE, MCPTools.START_OF_DAY));
  }

  @Test
  public void testUsesGivenZone() {
    assertEquals(
        1710460800000L,
        MCPTools.parseToEpochMillis("2024-03-15", ZoneId.of("UTC"), MCPTools.START_OF_DAY));
    assertEquals(
        1710457200000L, MCPTools.parseToEpochMillis("2024-03-15", ZONE, MCPTools.START_OF_DAY));
  }

  @Test
  public void testInvalidInput() {
    List<String> invalidInputs =
        List.of(
            "",
            " ",
            "abc",
            "15/03/2024",
            "2024-13-01",
            "2024-03-15X10:00:00",
            "2024-03-15T25:00:00");

    for (String invalid : invalidInputs) {
      IllegalArgumentException e =
          assertThrows(
              IllegalArgumentException.class,
              () -> MCPTools.parseToEpochMillis(invalid, ZONE, MCPTools.START_OF_DAY),
              invalid);
      assertTrue(e.getMessage().contains("yyyy-MM-dd"), e.getMessage());
    }

    assertThrows(
        IllegalArgumentException.class,
        () -> MCPTools.parseToEpochMillis(null, ZONE, MCPTools.START_OF_DAY));
  }

  @Test
  public void testResolveZoneDefaultsToConfiguredZone() {
    assertEquals(ZONE, MCPTools.resolveZone(null, ZONE));
    assertEquals(ZONE, MCPTools.resolveZone("", ZONE));
    assertEquals(ZONE, MCPTools.resolveZone("   ", ZONE));
  }

  @Test
  public void testResolveZoneUsesGivenZone() {
    assertEquals(ZoneId.of("UTC"), MCPTools.resolveZone("UTC", ZONE));
    assertEquals(ZoneId.of("Asia/Kuala_Lumpur"), MCPTools.resolveZone("Asia/Kuala_Lumpur", ZONE));
    // surrounding whitespace is tolerated
    assertEquals(ZoneId.of("UTC"), MCPTools.resolveZone(" UTC ", ZONE));
  }

  @Test
  public void testResolvedZoneDrivesDateBoundaries() {
    // Same date, different zones -> different epoch millis.
    assertEquals(
        1710460800000L,
        MCPTools.parseToEpochMillis(
            "2024-03-15", MCPTools.resolveZone("UTC", ZONE), MCPTools.START_OF_DAY));
    assertEquals(
        1710457200000L,
        MCPTools.parseToEpochMillis(
            "2024-03-15", MCPTools.resolveZone(null, ZONE), MCPTools.START_OF_DAY));
  }

  @Test
  public void testInvalidZone() {
    for (String invalid : List.of("Nowhere/Paris", "Europe Paris", "UTC++1")) {
      IllegalArgumentException e =
          assertThrows(
              IllegalArgumentException.class, () -> MCPTools.resolveZone(invalid, ZONE), invalid);
      assertTrue(e.getMessage().contains(invalid), e.getMessage());
    }
  }
}
