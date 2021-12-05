package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.jooq.impl.DSL;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.ftpix.sss.dsl.Tables.*;

@Component("categoryDaoJooq")
public class CategoryDao {
    private final DSLContext dslContext;

    private final List<DaoListener<Category>> listeners = new ArrayList<>();

    @Autowired
    public CategoryDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public Optional<Category> get(User user, long id) {
        return Optional.ofNullable(dslContext.select().from(CATEGORY)
                .where(CATEGORY.USER_ID.eq(user.getId().toString()), CATEGORY.ID.eq(id))
                .fetchOne(r -> {
                    Category c = r.into(Category.class);
                    c.setUser(user);
                    return c;
                }));
    }

    public void addListener(DaoListener<Category> listener) {
        listeners.add(listener);
    }


    public Category create(User user, Category category) {
        Long id = dslContext.insertInto(CATEGORY,
                        CATEGORY.ICON,
                        CATEGORY.CATEGORY_ORDER,
                        CATEGORY.USER_ID
                ).values(
                        category.getIcon(),
                        category.getCategoryOrder(),
                        user.getId().toString()
                ).returningResult(CATEGORY.ID)
                .fetchOne(r -> r.into(Long.class));
        category.setId(id);


        listeners.forEach(l -> l.afterInsert(user, category));
        return category;
    }

    public boolean update(User user, Category category) {
        Optional<Category> c = get(user, category.getId());
        if (c.isPresent()) {
            return dslContext.update(CATEGORY)
                    .set(CATEGORY.CATEGORY_ORDER, category.getCategoryOrder())
                    .set(CATEGORY.ICON, category.getIcon())
                    .where(CATEGORY.ID.eq(category.getId()))
                    .execute() == 1;
        } else {
            return false;
        }
    }

    public List<Category> getWhere(User user, Condition... filter) {

        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, CATEGORY.USER_ID.eq(user.getId().toString()));
        return dslContext.select().from(CATEGORY)
                .where(conditions)
                .orderBy(CATEGORY.CATEGORY_ORDER.asc())
                .fetch(r -> {
                    Category c = r.into(Category.class);
                    c.setUser(user);
                    return c;
                });
    }

    public long getMaxCategoryOrder(User user) {
        return dslContext.select(DSL.max(CATEGORY.CATEGORY_ORDER))
                .from(CATEGORY)
                .where(CATEGORY.USER_ID.eq(user.getId().toString()))
                .fetchOne(integerRecord1 -> {
                    return integerRecord1.get(0, Long.class);
                });
    }

    public boolean delete(User user, Category category) {
        boolean b = dslContext.delete(CATEGORY)
                .where(CATEGORY.USER_ID.eq(user.getId().toString()), CATEGORY.ID.eq(category.getId()))
                .execute() > 0;

        if (b) {
            listeners.forEach(l -> l.afterDelete(user, category));
        }

        return b;
    }

}
