package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.YearlyHistory;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.*;

@Component("yearlyHistoryDaoJooq")
public class YearlyHistoryDao {

    private final DSLContext dslContext;

    @Autowired
    public YearlyHistoryDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }


    public void deleteWhere(Condition... conditions) {
        if (conditions.length > 0) {
            dslContext.delete(YEARLY_HISTORY)
                    .where(conditions)
                    .execute();
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

    public Optional<YearlyHistory> getFirstWhere(Condition... conditions) {
        if (conditions.length > 0) {
            return dslContext.select().from(YEARLY_HISTORY)
                    .where(conditions)
                    .fetchOptional(r -> {
                        YearlyHistory history = r.into(YearlyHistory.class);
                        history.setCategory(getCategory(r.get(YEARLY_HISTORY.CATEGORY_ID)));
                        return history;
                    });
        } else {
            return Optional.empty();
        }
    }

    public void createOrUpdate(YearlyHistory monthlyHistory) {
        dslContext.insertInto(YEARLY_HISTORY,
                        YEARLY_HISTORY.ID,
                        YEARLY_HISTORY.CATEGORY_ID,
                        YEARLY_HISTORY.TOTAL,
                        YEARLY_HISTORY.DATE)
                .values(
                        UUID.randomUUID().toString(),
                        monthlyHistory.getCategory().getId(),
                        monthlyHistory.getTotal(),
                        monthlyHistory.getDate()
                ).onDuplicateKeyUpdate()
                .set(YEARLY_HISTORY.TOTAL, monthlyHistory.getTotal())
                .execute();
    }
}
