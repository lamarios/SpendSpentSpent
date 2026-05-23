package com.ftpix.sss.persistence.utils;

import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Path;
import org.springframework.data.jpa.domain.Specification;

import java.util.Collection;

public class Specifications<T> {

    private static <T> Path<?> resolvePath(jakarta.persistence.criteria.Root<T> root, String field) {
        String[] parts = field.split("\\.");
        Path<?> path = root.get(parts[0]);
        for (int i = 1; i < parts.length; i++) {
            path = path.get(parts[i]);
        }
        return path;
    }

    public static <T> Specification<T> equal(String field, Object value) {
        return (root, query, cb) -> value != null ? cb.equal(resolvePath(root, field), value) : null;
    }

    public static <T> Specification<T> notEqual(String field, Object value) {
        return (root, query, cb) -> value != null ? cb.notEqual(resolvePath(root, field), value) : null;
    }

    public static <T, Y extends Comparable<? super Y>> Specification<T> greaterThan(String field, Y value) {
        return (root, query, cb) -> value != null
                ? cb.greaterThan((Expression<Y>) resolvePath(root, field), value)
                : null;
    }

    public static <T, Y extends Comparable<? super Y>> Specification<T> greaterThanOrEqual(String field, Y value) {
        return (root, query, cb) -> value != null
                ? cb.greaterThanOrEqualTo((Expression<Y>) resolvePath(root, field), value)
                : null;
    }

    public static <T, Y extends Comparable<? super Y>> Specification<T> lessThan(String field, Y value) {
        return (root, query, cb) -> value != null
                ? cb.lessThan((Expression<Y>) resolvePath(root, field), value)
                : null;
    }

    public static <T, Y extends Comparable<? super Y>> Specification<T> lessThanOrEqual(String field, Y value) {
        return (root, query, cb) -> value != null
                ? cb.lessThanOrEqualTo((Expression<Y>) resolvePath(root, field), value)
                : null;
    }

    public static <T, Y extends Comparable<? super Y>> Specification<T> between(String field, Y from, Y to) {
        return (root, query, cb) -> (from != null && to != null)
                ? cb.between((Expression<Y>) resolvePath(root, field), from, to)
                : null;
    }

    public static <T> Specification<T> like(String field, String value) {
        return (root, query, cb) -> value != null
                ? cb.like(cb.upper((Expression<String>) resolvePath(root, field)), "%" + value.toUpperCase() + "%")
                : null;
    }

    public static <T> Specification<T> likeStartsWith(String field, String value) {
        return (root, query, cb) -> value != null
                ? cb.like(cb.upper((Expression<String>) resolvePath(root, field)), value.toUpperCase() + "%")
                : null;
    }

    public static <T> Specification<T> likeEndsWith(String field, String value) {
        return (root, query, cb) -> value != null
                ? cb.like(cb.upper((Expression<String>) resolvePath(root, field)), "%" + value.toUpperCase())
                : null;
    }

    public static <T> Specification<T> joinLike(String joinField, String field, String value) {
        return (root, query, cb) -> {
            if (value == null) return null;
            query.distinct(true);
            Join<T, ?> join = root.join(joinField, JoinType.LEFT);
            String[] parts = field.split("\\.");
            Path<?> path = join.get(parts[0]);
            for (int i = 1; i < parts.length; i++) {
                path = path.get(parts[i]);
            }
            return cb.like(cb.upper((Expression<String>) path), "%" + value.toUpperCase() + "%");
        };
    }

    public static <T> Specification<T> in(String field, Collection<?> values) {
        return (root, query, cb) -> (values != null && !values.isEmpty())
                ? resolvePath(root, field).in(values)
                : null;
    }

    public static <T> Specification<T> notIn(String field, Collection<?> values) {
        return (root, query, cb) -> (values != null && !values.isEmpty())
                ? cb.not(resolvePath(root, field).in(values))
                : null;
    }

    public static <T> Specification<T> isNull(String field) {
        return (root, query, cb) -> cb.isNull(resolvePath(root, field));
    }

    public static <T> Specification<T> isNotNull(String field) {
        return (root, query, cb) -> cb.isNotNull(resolvePath(root, field));
    }

    public static <T> Specification<T> diffBetween(String field1, String field2, long from, long to) {
        return (root, query, cb) -> cb.between(
                cb.diff(
                        (Expression<Long>) resolvePath(root, field1),
                        (Expression<Long>) resolvePath(root, field2)
                ), from, to
        );
    }
}