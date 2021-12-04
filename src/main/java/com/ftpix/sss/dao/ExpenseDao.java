package com.ftpix.sss.dao;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import org.jooq.Condition;
import org.jooq.impl.DefaultDSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.EXPENSE;

@Component("expenseDaoJooq")
public class ExpenseDao {

    private final DefaultDSLContext dslContext;


    @Autowired
    public ExpenseDao(DefaultDSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public List<Expense> getWhere(Condition... conditions) throws SQLException {
        Map<Long, Long> expenseIdToCategory = new HashMap<>();

        List<Expense> expenses = dslContext.select()
                .from(EXPENSE)
                .where(conditions)
                .fetch(record -> {
                    Expense into = record.into(Expense.class);
                    expenseIdToCategory.put(into.getId(), record.getValue(EXPENSE.CATEGORY_ID));
                    return into;
                });

        if (!expenses.isEmpty()) {
            List<Category> categories = dslContext.select().from(CATEGORY)
                    .where(CATEGORY.ID.in(expenseIdToCategory.values()))
                    .fetch(record -> record.into(Category.class));

            expenses.forEach(e -> {
                e.setCategory(categories.stream().filter(c -> c.getId() == expenseIdToCategory.get(e.getId())).findFirst().get());
            });
        }

        return expenses;
    }
}
