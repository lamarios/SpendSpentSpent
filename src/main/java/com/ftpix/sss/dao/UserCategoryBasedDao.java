package com.ftpix.sss.dao;

import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.PaginationService;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.Record;
import org.jooq.*;
import org.jooq.impl.TableImpl;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.CATEGORY;

public interface UserCategoryBasedDao<R extends UpdatableRecord<R>, M extends HasCategory> {
    DSLContext getDsl();

    void addListener(DaoUserListener<M> listener);

    List<DaoUserListener<M>> getListeners();

    TableImpl<R> getTable();

    M fromRecord(R record, Map<Long, Category> categories);

    R toRecord(M object);

    Field<Long> getCategoryField();


    default List<M> getWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);

        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));
        return getDsl().select()
                .from(getTable())
                .where(conditions)
                .fetch(r -> fromRecord((R) r, userCategories));
    }

    default PaginatedResults<M> getPaginatedWhere(User user, int page, int pageSize, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));

        SelectConditionStep<Record> where = getDsl().select().from(getTable())
                .where(conditions);

        return PaginationService.getPaginatedResults(where, page, pageSize, r -> fromRecord((R) r, userCategories));
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
            R r = toRecord(object);
            boolean result = getDsl().executeDelete(r) == 1;
            getListeners().forEach(l -> l.afterDelete(user, object));
            return result;
        } else {
            return false;
        }
    }

    default boolean insert(User user, M object) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (userCategories.containsKey(object.getCategory().getId())) {
            R r = toRecord(object);
            boolean result = getDsl().executeInsert(r) == 1;
            getListeners().forEach(l -> l.afterInsert(user, object));
            return result;
        } else {
            return false;
        }
    }

    default boolean update(User user, M object) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (userCategories.containsKey(object.getCategory().getId())) {

            R r = toRecord(object);
            return getDsl().executeUpdate(r) == 1;
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

}
