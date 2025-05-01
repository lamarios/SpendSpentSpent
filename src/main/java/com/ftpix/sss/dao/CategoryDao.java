package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.CategoryRecord;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.OrderField;
import org.jooq.impl.DSL;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.ftpix.sss.dsl.Tables.CATEGORY;

@Component("categoryDaoJooq")
public class CategoryDao implements UserCategoryBasedDao<CategoryRecord, Category> {
    private final DSLContext dslContext;

    private final List<DaoUserListener<Category>> listeners = new ArrayList<>();

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

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addUserBasedListener(DaoUserListener<Category> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoUserListener<Category>> getUserBasedListeners() {
        return listeners;
    }

    @Override
    public TableImpl<CategoryRecord> getTable() {
        return CATEGORY;
    }

    @Override
    public Category fromRecord(CategoryRecord r, Map<Long, Category> categories) {
        return categories.get(r.getId());
    }

    @Override
    public CategoryRecord setRecordData(CategoryRecord r, Category o) {
        r.setIcon(o.getIcon());
        if(o.getId() != null) {
            r.setId(o.getId());
        }
        r.setUserId(o.getUser().getId().toString());
        r.setCategoryOrder(o.getCategoryOrder());

        return r;
    }



    /**
     * Needs override because otherwise it will check if the category we try to insert already exists ?
     *
     * @param user
     * @param object
     * @return
     */
    @Override
    public Category insert(User user, Category object) {
        CategoryRecord r = setRecordData(dslContext.newRecord(CATEGORY), object);
        r.insert();
        getUserBasedListeners().forEach(l -> l.afterInsert(user, object));
        return fromRecord(r, getUserCategories(user));
    }

    @Override
    public Field<Long> getCategoryField() {
        return CATEGORY.ID;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{CATEGORY.CATEGORY_ORDER.asc()};
    }

    public long getMaxCategoryOrder(User user) {
        try {
            return dslContext.select(DSL.max(CATEGORY.CATEGORY_ORDER))
                    .from(CATEGORY)
                    .where(CATEGORY.USER_ID.eq(user.getId().toString()))
                    .fetchOne(integerRecord1 -> {
                        return integerRecord1.get(0, Long.class);
                    });
        } catch (Exception e) {
            return 0L;
        }
    }

    public List<Category> queryForAll() {
        return dslContext.select().from(CATEGORY).fetch(r -> r.into(Category.class));
    }
}
