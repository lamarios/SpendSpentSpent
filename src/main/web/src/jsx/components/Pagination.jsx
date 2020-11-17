import React from 'react';

const Pagination = (props) => {

    const pages = [];

    for (let i = 0; i < props.pagination.totalPages; i++) {
        pages.push(<div key={i} className={(props.pagination.page === i ? "current " : "") + "page"}
                        onClick={() => props.setPage(i)}>{i + 1}</div>)
    }

    return <div className="Pagination">
        {props.pagination.totalPages > 1 && <div className="pages">
            {pages}
        </div>}
        <div className="count">{props.pagination.currentPageCount} of {props.pagination.total}</div>
    </div>
}

export default Pagination;