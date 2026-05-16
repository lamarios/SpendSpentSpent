package com.ftpix.sss.persistence.utils;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import org.springframework.data.jpa.domain.Specification;

import java.util.Collection;

public class ExpenseSpecifications {

    public static Specification<Expense> betweenTimestamps(long from, long to) {
        return (root, query, cb) -> cb.between(root.get("timestamp"), from, to);
    }

    public static Specification<Expense> inCategories(Collection<Category> categories) {
        return (root, query, cb) -> root.get("category").in(categories);
    }

    public static Specification<Expense> excludeRecurring() {
        return (root, query, cb) -> cb.notEqual(root.get("type"), Expense.TYPE_RECURRENT);
    }

    public static Specification<Expense> createdOnTheSpot(){
        long oneMinute = 1000 * 60L;
        return (root, query, cb) -> cb.between(
                cb.diff(root.<Long>get("timestamp"), root.<Long>get("timeCreated")),
                -oneMinute,
                oneMinute
        );
    }

    public static <T> Specification<Expense> equal(String field, T value) {
        return (root, query, cb) -> value != null ? cb.equal(root.get(field), value) : null;
    }
}
