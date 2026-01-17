package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Keys;
import com.ftpix.sss.dsl.tables.records.CategoryRecord;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.HouseholdInviteStatus;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.models.User;
import com.ftpix.sss.utils.PaginationUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.jooq.*;
import org.jooq.impl.DSL;
import org.jooq.impl.TableImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.*;

public interface HouseholdCategoryBaseDao<R extends TableRecord<R>, M extends HasCategory> {
    DSLContext getDsl();

    TableImpl<R> getTable();

    M fromRecord(R record, Map<Long, Category> categories);

    R setRecordData(R record, M object);

    Field<Long> getCategoryField();

    OrderField[] getDefaultOrderBy();


    default Map<Long, Category> getHouseholdCategories(User user) {
        var userDao = new UserDao(getDsl());
        // fetching the use household if there's one
        var id = getDsl().select(HOUSEHOLD_MEMBERS.HOUSEHOLD_ID)
                .from(HOUSEHOLD_MEMBERS)
                .where(HOUSEHOLD_MEMBERS.USER_ID.eq(user.getId().toString()))
                .and(HOUSEHOLD_MEMBERS.STATUS.eq(HouseholdInviteStatus.accepted.name()))
                .fetchOne(stringRecord1 -> stringRecord1.get(HOUSEHOLD_MEMBERS.HOUSEHOLD_ID));


        List<String> userIds = new ArrayList<>();
        userIds.add(user.getId().toString());


        if (id != null) {

            var users = getDsl().select(HOUSEHOLD_MEMBERS.USER_ID)
                    .from(HOUSEHOLD_MEMBERS)
                    .where(HOUSEHOLD_MEMBERS.HOUSEHOLD_ID.eq(id))
                    .and(HOUSEHOLD_MEMBERS.STATUS.eq(HouseholdInviteStatus.accepted.name()))
                    .and(HOUSEHOLD_MEMBERS.USER_ID.notEqual(user.getId().toString()))
                    .fetch(stringRecord1 -> stringRecord1.get(HOUSEHOLD_MEMBERS.USER_ID));

            userIds.addAll(users);
        }

        return getDsl().select().from(CATEGORY)
                .where(CATEGORY.USER_ID.in(userIds))
                .fetch((r) -> {

                    Category into = r.into(Category.class);

                    CategoryRecord catR = (CategoryRecord) r;

                    var userRecord = ((CategoryRecord) r).fetchParent(Keys.CATEGORY__FK_CATEGORY_USER);
                    if (userRecord != null) {
                        var categoryUser = userDao.fromRecord(userRecord);
                        // remove private stuff as this could be shared
                        categoryUser.setPassword(null);
                        categoryUser.setOidcSub(null);
                        categoryUser.setShowAnnouncement(false);
                        categoryUser.setSubscriptionExpiryDate(0);
                        into.setUser(categoryUser);
                    }

                    return into;
                })
                .stream().collect(Collectors.toMap(Category::getId, Function.identity()));

    }


    default List<M> getFromHouseholdWhere(User user, Condition... filter) {
        return getFromHouseholdWhere(user, getDefaultOrderBy(), filter);
    }


    default List<M> getFromHouseholdWhere(User user, OrderField[] orderBy, Condition... filter) {
        Map<Long, Category> userCategories = getHouseholdCategories(user);

        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));
        return getDsl().select()
                .from(getTable())
                .where(conditions)
                .orderBy(orderBy)
                .fetch(r -> fromRecord((R) r, userCategories));
    }

    default PaginatedResults<M> getFromHouseholdPaginatedWhere(User user, int page, int pageSize, OrderField[] orderBy, Condition... filter) {
        if (page < 0) {
            page = PaginationUtils.DEFAULT_PAGE;
        }
        if (pageSize <= 0) {
            pageSize = PaginationUtils.DEFAULT_PAGE_SIZE;
        }

        Map<Long, Category> userCategories = getHouseholdCategories(user);
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

}
