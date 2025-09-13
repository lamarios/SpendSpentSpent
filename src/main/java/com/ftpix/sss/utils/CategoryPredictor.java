package com.ftpix.sss.utils;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;

import java.time.*;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

public class CategoryPredictor {

    // Map: day -> time bucket -> category -> count
    private final Map<String, Map<String, Map<Category, Integer>>> stats = new HashMap<>();

    /**
     * Train the predictor with a list of expenses, using ZoneId to extract day & time from timestamp.
     */
    public void train(List<Expense> expenses, ZoneId zoneId) {
        for (Expense e : expenses) {
            if (e.getCategory() == null) continue;

            ZonedDateTime zdt = Instant.ofEpochMilli(e.getTimestamp()).atZone(zoneId);
            String day = zdt.getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.ENGLISH);
            String timeBucket = bucketizeTime(zdt.getHour());

            stats
                    .computeIfAbsent(day, k -> new HashMap<>())
                    .computeIfAbsent(timeBucket, k -> new HashMap<>())
                    .merge(e.getCategory(), 1, Integer::sum);
        }
    }

    /**
     * Predict ordered list of categories with probabilities for a given (day, hour).
     */
    public List<CategoryPrediction> predict(DayOfWeek dayOfWeek, int hour) {
        String day = dayOfWeek.getDisplayName(TextStyle.FULL, Locale.ENGLISH);
        String timeBucket = bucketizeTime(hour);

        Map<String, Map<Category, Integer>> dayStats = stats.get(day);

        if (dayStats != null && dayStats.containsKey(timeBucket)) {
            return calculateProbabilities(dayStats.get(timeBucket));
        }

        // fallback: overall probabilities
        return calculateProbabilities(getOverallCounts());
    }

    /**
     * Helper: classify hour into buckets.
     */
    private String bucketizeTime(int hour) {
        if (hour >= 5 && hour < 12) return "Morning";
        else if(hour >= 11 && hour < 14) return "Noon";
        else if (hour >= 14 && hour < 17) return "Afternoon";
        else if (hour >= 17 && hour < 21) return "Evening";
        else return "Night";
    }

    /**
     * Fallback: Get overall category counts.
     */
    private Map<Category, Integer> getOverallCounts() {
        Map<Category, Integer> overallCounts = new HashMap<>();
        for (Map<String, Map<Category, Integer>> timeMap : stats.values()) {
            for (Map<Category, Integer> catMap : timeMap.values()) {
                for (Map.Entry<Category, Integer> entry : catMap.entrySet()) {
                    overallCounts.merge(entry.getKey(), entry.getValue(), Integer::sum);
                }
            }
        }
        return overallCounts;
    }

    /**
     * Convert raw counts into probabilities.
     */
    private List<CategoryPrediction> calculateProbabilities(Map<Category, Integer> counts) {
        int total = counts.values().stream().mapToInt(Integer::intValue).sum();

        return counts.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue())) // descending
                .map(e -> new CategoryPrediction(
                        e.getKey(),
                        (double) e.getValue() / total
                ))
                .collect(Collectors.toList());
    }

    /**
     * Inner class to hold category + probability.
     */
    public static class CategoryPrediction {
        private final Category category;
        private final double probability;

        public CategoryPrediction(Category category, double probability) {
            this.category = category;
            this.probability = probability;
        }

        public Category getCategory() {
            return category;
        }

        public double getProbability() {
            return probability;
        }

        @Override
        public String toString() {
            return "CategoryPrediction{" +
                    "categoryId=" + (category.getId() != null ? category.getId() : "null") +
                    ", probability=" + String.format("%.2f", probability * 100) + "%" +
                    '}';
        }
    }
}

