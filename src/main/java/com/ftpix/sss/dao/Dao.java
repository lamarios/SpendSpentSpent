package com.ftpix.sss.dao;

import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.services.PaginationService;
import org.jooq.Record;
import org.jooq.*;
import org.jooq.impl.TableImpl;

import java.util.List;
import java.util.Optional;

public interface Dao<R extends UpdatableRecord<R>, M> {
    DSLContext getDsl();

    void addListener(DaoListener<M> listener);

    List<DaoListener<M>> getListeners();

    TableImpl<R> getTable();

    M fromRecord(R record);

    R toRecord(M object);

    default List<M> getWhere(Condition... filter) {
        return getDsl().select()
                .from(getTable())
                .where(filter)
                .fetch(r -> fromRecord((R) r));
    }

    default PaginatedResults<M> getPaginatedWhere(int page, int pageSize, Condition... filter) {
        SelectConditionStep<Record> where = getDsl().select().from(getTable())
                .where(filter);

        return PaginationService.getPaginatedResults(where, page, pageSize, r -> fromRecord((R) r));
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
        R r = toRecord(object);
        boolean result = getDsl().executeDelete(r) == 1;
        getListeners().forEach(l -> l.afterDelete(object));
        return result;
    }

    default boolean insert(M object) {
        R r = toRecord(object);
        boolean result = getDsl().executeInsert(r) == 1;
        getListeners().forEach(l -> l.afterInsert(object));

        return result;
    }

    default boolean update(M object) {
        R r = toRecord(object);
        return getDsl().executeUpdate(r) == 1;
    }


}
