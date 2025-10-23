package com.ftpix.sss.dao;

import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.utils.PaginationUtils;
import org.jooq.*;
import org.jooq.impl.DSL;
import org.jooq.impl.TableImpl;

import java.util.List;
import java.util.Optional;

public interface Dao<R extends TableRecord<R>, M> {
    DSLContext getDsl();

    void addListener(DaoListener<M> listener);

    List<DaoListener<M>> getListeners();

    TableImpl<R> getTable();

    M fromRecord(R record);

    R setRecordData(R r, M object);

    OrderField[] getDefaultOrderBy();


    default List<M> getWhere(Condition... filter) {
        return getWhere(getDefaultOrderBy(), filter);
    }

    default List<M> getWhere(OrderField[] orderBy, Condition... filter) {
        return getDsl().select()
                .from(getTable())
                .where(filter)
                .fetch(r -> fromRecord((R) r));
    }


    default PaginatedResults<M> getPaginatedWhere(int page, int pageSize, Condition... filter) {
        return getPaginatedWhere(page, pageSize, getDefaultOrderBy(), filter);
    }

    default PaginatedResults<M> getPaginatedWhere(int page, int pageSize, OrderField[] orderBy, Condition... filter) {
        if (page < 0) {
            page = PaginationUtils.DEFAULT_PAGE;
        }
        if (pageSize <= 0) {
            pageSize = PaginationUtils.DEFAULT_PAGE_SIZE;
        }
        List<M> results = getDsl().select().from(getTable())
                .where(filter)
                .orderBy(orderBy)
                .limit(pageSize)
                .offset(page * pageSize)
                .fetch(r -> fromRecord((R) r));

        Integer count = getDsl().select(DSL.count()).from(getTable())
                .where(filter)
                .fetchOne().into(Integer.class);

        return new PaginatedResults<>(page, count, pageSize, results);
    }

    default int deleteWhere(Condition... filter) {
        // we try not to delete all so we need conditions
        if (filter.length > 0) {
            return getDsl().delete(getTable())
                    .where(filter)
                    .execute();
        } else {
            return 0;
        }
    }

    default Optional<M> getOneWhere(Condition... filter) {
        if (filter.length > 0) {
            return getDsl().fetchOptional(getTable(), filter).map(this::fromRecord);
        } else {
            return Optional.empty();
        }
    }

    default boolean delete(M object) {
        R r = setRecordData(getDsl().newRecord(getTable()), object);
        if (r instanceof UpdatableRecord updatable) {
            boolean result = updatable.delete() == 1;
            getListeners().forEach(l -> l.afterDelete(object));
            return result;
        } else {
            throw new RuntimeException("record type is not updatable");
        }
    }

    default M insert(M object) {
        R r = setRecordData(getDsl().newRecord(getTable()), object);
        r.insert();
        getListeners().forEach(l -> l.afterInsert(object));
        return fromRecord(r);
    }

    default boolean update(M object) {
        R r = setRecordData(getDsl().newRecord(getTable()), object);
        if (r instanceof UpdatableRecord updatable) {
            return updatable.update() == 1;
        } else {
            throw new RuntimeException("record type is not updatable");
        }

    }

    default boolean importMany(List<M> objects) {
        objects.forEach(m -> {
            R r = setRecordData(getDsl().newRecord(getTable()), m);
            r.insert();
        });
        return true;
    }

}
