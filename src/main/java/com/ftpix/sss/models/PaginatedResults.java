package com.ftpix.sss.models;

import java.util.ArrayList;
import java.util.List;

public class PaginatedResults<T> {
    private final List<T> data;
    private final PaginationDetails pagination;

    public static <T> PaginatedResults<T> empty(long pageSize) {
        return new PaginatedResults<T>(0, 0, pageSize, new ArrayList<T>());
    }

    public PaginatedResults(long page, long total, long pageSize, List<T> data) {
        this.data = data;
        this.pagination = new PaginationDetails(data.size(), page, total, pageSize);
    }

    public PaginationDetails getPagination() {
        return pagination;
    }

    public List<T> getData() {
        return data;
    }


    public static class PaginationDetails {


        private final long totalPages, currentPageCount;
        private final long page;
        private final long total;
        private final long pageSize;

        public PaginationDetails(long currentPageCount, long page, long total, long pageSize) {
            this.totalPages = (long) Math.ceil(total / pageSize);
            this.currentPageCount = currentPageCount;
            this.page = page;
            this.total = total;
            this.pageSize = pageSize;
        }

        public long getTotalPages() {
            return totalPages;
        }

        public long getCurrentPageCount() {
            return currentPageCount;
        }

        public long getPage() {
            return page;
        }

        public long getTotal() {
            return total;
        }

        public long getPageSize() {
            return pageSize;
        }
    }
}

