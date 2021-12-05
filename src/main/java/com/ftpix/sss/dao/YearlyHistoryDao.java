package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

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
}
