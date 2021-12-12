package com.ftpix.sss.utils;


import com.ftpix.sss.models.PaginatedResults;
import org.jooq.Record;
import org.jooq.RecordMapper;
import org.jooq.SelectConditionStep;
import org.jooq.SelectForUpdateStep;

import java.sql.SQLException;
import java.util.List;

public class PaginationUtils {
    public final static int DEFAULT_PAGE_SIZE = 20, DEFAULT_PAGE = 0;


    /**
     * Gets paginated results based on a given query
     *
     * @param page     which page to get (starts from 0)
     * @param pageSize how many results per page
     * @param <T>      The type of entities to get
     * @param <U>      The type of it's primary key
     * @return paginated results
     * @throws SQLException if anything goes wrong
     */
    public static <U extends Record, T> PaginatedResults<T> getPaginatedResults(SelectConditionStep<U> select, long page, long pageSize, RecordMapper<U, T> mapper) {
        if (page < 0) {

            page = 0;
        }
        if (pageSize <= 0) {
            pageSize = 20;
        }

        // getting the total count of items before applying the pagination parameters
        select.fetch().size();
        final long count = select.fetch().size();

        SelectForUpdateStep<U> offset = select.limit(pageSize).offset(pageSize * page);

        final List<T> results = offset.fetch(mapper);

        return new PaginatedResults<T>(page, count, pageSize, results);
    }

}
