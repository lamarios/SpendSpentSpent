package com.ftpix.sss.utils;

import org.apache.commons.lang3.tuple.Pair;

import java.time.*;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.Date;

public class DateUtils {

    public static LocalDate convertToLocalDateViaInstant(Date dateToConvert) {
        return dateToConvert.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
    }

    public static ZonedDateTime fromTimestamp(long timestamp, ZoneId zoneId) {
        return ZonedDateTime.ofInstant(Instant.ofEpochMilli(timestamp), zoneId);
    }

    public static Pair<ZonedDateTime, ZonedDateTime> getMonthBoundaries(ZonedDateTime month, ZoneId zoneId) {
        return Pair.of(
                month.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0).truncatedTo(ChronoUnit.DAYS),
                month.with(TemporalAdjusters.lastDayOfMonth())
                        .withHour(23)
                        .withMinute(59)
                        .withSecond(59)
        );
    }

    public static ZoneId parseZoneId(String zone, ZoneId defaultValue) {
        if (zone == null || zone.equalsIgnoreCase("Etc/Unknown") || zone.trim().isEmpty()) {
            return defaultValue;
        }
        return ZoneId.of(zone);
    }
}
