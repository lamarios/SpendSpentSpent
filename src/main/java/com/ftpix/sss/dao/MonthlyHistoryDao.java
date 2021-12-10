package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.MonthlyHistory;
import com.ftpix.sss.services.HistoryService;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.MONTHLY_HISTORY;

@Component("monthlyHistoryDaoJooq")
public class MonthlyHistoryDao {
    private final DSLContext dslContext;

    @Autowired
    public MonthlyHistoryDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public void deleteWhere(Condition... conditions) {
        if (conditions.length > 0) {
            dslContext.delete(MONTHLY_HISTORY)
                    .where(conditions).execute();
        }
    }

    private Category getCategory(long id) {
        return dslContext.select()
                .from(CATEGORY)
                .where(CATEGORY.ID.eq(id))
                .fetchOne(r -> {
                    return r.into(Category.class);
                });
    }

    public Optional<MonthlyHistory> getFirstWhere(Condition... conditions) {
        if (conditions.length > 0) {
            return dslContext.select().from(MONTHLY_HISTORY)
                    .where(conditions)
                    .fetchOptional(r -> {
                        MonthlyHistory history = r.into(MonthlyHistory.class);
                        history.setCategory(getCategory(r.get(MONTHLY_HISTORY.CATEGORY_ID)));
                        return history;
                    });
        } else {
            return Optional.empty();
        }
    }

    public void createOrUpdate(MonthlyHistory monthlyHistory) {
        dslContext.insertInto(MONTHLY_HISTORY,
                        MONTHLY_HISTORY.ID,
                        MONTHLY_HISTORY.CATEGORY_ID,
                        MONTHLY_HISTORY.TOTAL,
                        MONTHLY_HISTORY.DATE)
                .values(
                        UUID.randomUUID().toString(),
                        monthlyHistory.getCategory().getId(),
                        monthlyHistory.getTotal(),
                        monthlyHistory.getDate()
                ).onDuplicateKeyUpdate()
                .set(MONTHLY_HISTORY.TOTAL, monthlyHistory.getTotal())
                .execute();
    }
}
