package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.ExpenseRecord;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.OrderField;
import org.jooq.Record;
import org.jooq.impl.DefaultDSLContext;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.EXPENSE;

@Component("expenseDaoJooq")
public class ExpenseDao implements UserCategoryBasedDao<ExpenseRecord, Expense> {

    private final DefaultDSLContext dslContext;
    private final DateTimeFormatter date = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    private final DateTimeFormatter time = DateTimeFormatter.ofPattern("HH:mm");

    private final List<DaoUserListener<Expense>> listeners = new ArrayList<>();

    @Autowired
    public ExpenseDao(DefaultDSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public Optional<Expense> get(User user, long id) {
        return getOneWhere(user, EXPENSE.ID.eq(id));
    }

    @Override
    public void addUserBasedListener(DaoUserListener<Expense> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoUserListener<Expense>> getUserBasedListeners() {
        return listeners;
    }

    /**
     * Gets available months of expenses
     *
     * @param user
     * @return
     */
    public List<String> getMonths(User user) {
        Map<Long, Category> userCategories = getUserCategories(user);

        return dslContext.selectDistinct(EXPENSE.DATE)
                .from(EXPENSE)
                .where(EXPENSE.CATEGORY_ID.in(userCategories.keySet()))
                .fetch(r -> r.get(EXPENSE.DATE))
                .stream()
                .map(s -> s.substring(0, 7))
                .sorted()
                .distinct()
                .collect(Collectors.toList());
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public TableImpl<ExpenseRecord> getTable() {
        return EXPENSE;
    }

    @Override
    public Expense fromRecord(ExpenseRecord r, Map<Long, Category> categories) {
        try {
            Expense e = new Expense();
            e.setId(r.getId());
            e.setCategory(categories.get(r.getCategoryId()));
            e.setType(r.getType());
            e.setAmount(r.getAmount());
            e.setIncome(r.getIncome() != null && r.getIncome().equals((byte) 1));
            e.setDate(dateFormat.parse(r.getDate()));
            e.setLatitude(r.getLatitude());
            e.setLongitude(r.getLongitude());
            e.setTime(r.getTime());
            e.setTimestamp(r.getTimestamp());
            e.setNote(r.getNote());
            return e;
        } catch (ParseException ex) {
            throw new RuntimeException(ex);
        }

    }

    @Override
    public ExpenseRecord setRecordData(ExpenseRecord r, Expense o) {
        r.setId(o.getId());
        r.setCategoryId(o.getCategory().getId());
        r.setType(o.getType());
        r.setAmount(o.getAmount());
        r.setIncome((byte) (o.isIncome() ? 1 : 0));
        r.setDate(dateFormat.format(o.getDate()));
        r.setLatitude(o.getLatitude());
        r.setLongitude(o.getLongitude());
        r.setTime(o.getTime());
        r.setTimestamp(o.getTimestamp());
        r.setNote(o.getNote());
        return r;
    }

    @Override
    public Field<Long> getCategoryField() {
        return EXPENSE.CATEGORY_ID;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{EXPENSE.DATE.desc()};
    }

    public long countExpenses(User user, long categoryId) {
        Map<Long, Category> userCategories = getUserCategories(user);
        return dslContext.fetchCount(EXPENSE, EXPENSE.CATEGORY_ID.in(userCategories.keySet()), EXPENSE.CATEGORY_ID.eq(categoryId));
    }
}
