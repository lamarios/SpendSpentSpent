package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.FilesRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.AiProcessingStatus;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.websockets.WebSocketSessionManager;
import com.google.gson.Gson;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.OrderField;
import org.jooq.TableField;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.FILES;

@Component("fileDao")
public class FileDAO implements Dao<FilesRecord, SSSFile> {
    private final DSLContext dslContext;
    private final Gson gson;
    private final List<DaoListener<SSSFile>> listeners = new ArrayList<>();

    @Autowired
    public FileDAO(DSLContext dslContext, Gson gson) {
        this.dslContext = dslContext;
        this.gson = gson;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addListener(DaoListener<SSSFile> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoListener<SSSFile>> getListeners() {
        return listeners;
    }

    @Override
    public TableImpl<FilesRecord> getTable() {
        return FILES;
    }

    @Override
    public boolean update(SSSFile object) {
        boolean update = Dao.super.update(object);
        WebSocketSessionManager.sendToUser(object.getUserId().toString(), object);
        return update;
    }


    public boolean clearExpenseFiles(Long expenseId) {
        return getDsl().update(FILES).setNull(FILES.EXPENSE_ID).where(FILES.EXPENSE_ID.eq(expenseId)).execute() > 0;
    }

    public <T> boolean updateField(SSSFile file, Field<T> field, T value) {
        return getDsl().update(FILES).set(field, value).where(FILES.ID.eq(file.getId().toString())).execute() == 1;
    }

    @Override
    public SSSFile fromRecord(FilesRecord record) {
        SSSFile f = new SSSFile();
        f.setId(UUID.fromString(record.getId()));
        f.setUserId(UUID.fromString(record.getUserId()));
        f.setExpenseId(record.getExpenseId());
        f.setStatus(AiProcessingStatus.valueOf(record.getStatus()));
        f.setTimeCreated(record.getTimeCreated());
        f.setTimeUpdated(record.getTimeUpdated());
        if (record.getAiTags() != null) {
            f.setAiTags(Arrays.stream(record.getAiTags().split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .toList());
        }

        if (record.getAmounts() != null) {
            f.setAmounts(Arrays.stream(record.getAmounts().split(","))
                    .map(String::trim)
                    .filter(trim -> !trim.isEmpty())
                    .map(Double::parseDouble)
                    .sorted((o1, o2) -> Double.compare(o2, o1))
                    .collect(Collectors.toList()));
        }

        f.setFileName(record.getFileName());

        return f;
    }

    @Override
    public FilesRecord setRecordData(FilesRecord record, SSSFile f) {
        if (f.getId() == null) {
            f.setId(UUID.randomUUID());
        }

        record.setId(f.getId().toString());
        record.setUserId(f.getUserId().toString());
        record.setExpenseId(f.getExpenseId());
        record.setStatus(f.getStatus().name());
        record.setTimeCreated(f.getTimeCreated());
        record.setTimeUpdated(System.currentTimeMillis());
        if (f.getAiTags() != null) {
            record.setAiTags(String.join(",", f.getAiTags()));
        }
        if (f.getAmounts() != null) {
            record.setAmounts(String.join(",", f.getAmounts().stream().map(Object::toString).toList()));
        }
        record.setFileName(f.getFileName());


        return record;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[0];
    }
}
