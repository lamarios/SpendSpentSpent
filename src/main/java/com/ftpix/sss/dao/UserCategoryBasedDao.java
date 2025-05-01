package com.ftpix.sss.dao;

import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.models.User;
import com.ftpix.sss.utils.PaginationUtils;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.*;
import org.jooq.impl.DSL;
import org.jooq.impl.TableImpl;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.CATEGORY;

public interface UserCategoryBasedDao<R extends UpdatableRecord<R>, M extends HasCategory> {
    DSLContext getDsl();

    void addUserBasedListener(DaoUserListener<M> listener);

    List<DaoUserListener<M>> getUserBasedListeners();

    TableImpl<R> getTable();

    M fromRecord(R record, Map<Long, Category> categories);

    R setRecordData(R record, M object);

    Field<Long> getCategoryField();

    OrderField[] getDefaultOrderBy();

    default List<M> getWhere(User user, Condition... filter) {
        return getWhere(user, getDefaultOrderBy(), filter);
    }


    default List<M> getWhere(User user, OrderField[] orderBy, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);

        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));
        return getDsl().select()
                .from(getTable())
                .where(conditions)
                .orderBy(orderBy)
                .fetch(r -> fromRecord((R) r, userCategories));
    }

    default PaginatedResults<M> getPaginatedWhere(User user, int page, int pageSize, Condition... filter) {
        return getPaginatedWhere(user, page, pageSize, getDefaultOrderBy(), filter);
    }

    default PaginatedResults<M> getPaginatedWhere(User user, int page, int pageSize, OrderField[] orderBy, Condition... filter) {
        if (page < 0) {
            page = PaginationUtils.DEFAULT_PAGE;
        }
        if (pageSize <= 0) {
            pageSize = PaginationUtils.DEFAULT_PAGE_SIZE;
        }

        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));

        int offset = page * pageSize;
        List<M> results = getDsl().select().from(getTable())
                .where(conditions)
                .orderBy(orderBy)
                .limit(pageSize)
                .offset(offset)
                .fetch(r -> fromRecord((R) r, userCategories));

        Integer count = getDsl().select(DSL.count().as("count")).from(getTable())
                .where(conditions)
                .fetchOne(r -> r.get("count", Integer.class));

        return new PaginatedResults<>(page, count, pageSize, results);
    }

    default int deleteWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));
        // we try not to delete all so we need conditions
        if (filter.length > 0) {
            return getDsl().delete(getTable())
                    .where(conditions)
                    .execute();
        } else {
            return 0;
        }
    }

    default Optional<M> getOneWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));

        if (filter.length > 0) {
            return getDsl().fetchOptional(getTable(), conditions).map(r -> fromRecord(r, userCategories));
        } else {
            return Optional.empty();
        }
    }

    default boolean delete(User user, M object) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (userCategories.containsKey(object.getCategory().getId())) {
            R r = setRecordData(getDsl().newRecord(getTable()), object);
            boolean result = r.delete() == 1;
            getUserBasedListeners().forEach(l -> l.afterDelete(user, object));
            return result;
        } else {
            return false;
        }
    }

    default M insert(User user, M object) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (userCategories.containsKey(object.getCategory().getId())) {
            R r = setRecordData(getDsl().newRecord(getTable()), object);
            r.store();
            getUserBasedListeners().forEach(l -> l.afterInsert(user, object));
            return fromRecord(r, userCategories);
        } else {
            return null;
        }
    }

    default boolean update(User user, M object) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (userCategories.containsKey(object.getCategory().getId())) {

            R r = setRecordData(getDsl().newRecord(getTable()), object);
            return r.update() == 1;
        } else {
            return false;
        }
    }


    /**
     * Base filter to get any expense
     *
     * @param user
     * @return
     */
    default Map<Long, Category> getUserCategories(User user) {
        return getDsl().select().from(CATEGORY)
                .where(CATEGORY.USER_ID.eq(user.getId().toString()))
                .fetch(record -> {
                    Category into = record.into(Category.class);
                    into.setUser(user);
                    return into;
                })
                .stream().collect(Collectors.toMap(Category::getId, Function.identity()));
    }


    default boolean importManyForUsers(List<M> objects) {
        objects.forEach(m -> {
            R r = setRecordData(getDsl().newRecord(getTable()), m);
            r.insert();
        });
        return true;
    }
}
