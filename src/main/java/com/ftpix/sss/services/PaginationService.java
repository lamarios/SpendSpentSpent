package com.ftpix.sss.services;


import com.ftpix.sss.models.PaginatedResults;
import com.j256.ormlite.stmt.QueryBuilder;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;

@Service
public class PaginationService {
    private final int DEFAULT_PAGE_SIZE = 20, DEFAULT_PAGE = 0;


    /**
     * Gets paginated results based on a given query
     *
     * @param builder  the ormlite query builder
     * @param page     which page to get (starts from 0)
     * @param pageSize how many results per page
     * @param <T>      The type of entities to get
     * @param <U>      The type of it's primary key
     * @return paginated results
     * @throws SQLException if anything goes wrong
     */
    public <T, U> PaginatedResults<T> getPaginatedResults(QueryBuilder<T, U> builder, long page, long pageSize) throws SQLException {
        if (page < 0) {

            page = 0;
        }
        if (pageSize <= 0) {
            pageSize = 20;
        }

        // getting the total count of items before applying the pagination parameters
        final long count = builder.countOf();

        builder.limit(pageSize);
        builder.offset(pageSize * page);

        final List<T> results = builder.query();

        return new PaginatedResults<T>(page, count, pageSize, results);
    }

}
