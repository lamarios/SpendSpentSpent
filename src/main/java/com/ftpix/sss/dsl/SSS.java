/*
 * This file is generated by jOOQ.
 */
package com.ftpix.sss.dsl;


import com.ftpix.sss.dsl.tables.Category;
import com.ftpix.sss.dsl.tables.Expense;
import com.ftpix.sss.dsl.tables.MonthlyHistory;
import com.ftpix.sss.dsl.tables.RecurringExpense;
import com.ftpix.sss.dsl.tables.ResetPassword;
import com.ftpix.sss.dsl.tables.SchemaVersion;
import com.ftpix.sss.dsl.tables.Settings;
import com.ftpix.sss.dsl.tables.User;
import com.ftpix.sss.dsl.tables.YearlyHistory;

import java.util.Arrays;
import java.util.List;

import org.jooq.Catalog;
import org.jooq.Table;
import org.jooq.impl.SchemaImpl;


/**
 * This class is generated by jOOQ.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class SSS extends SchemaImpl {

    private static final long serialVersionUID = 1L;

    /**
     * The reference instance of <code>sss</code>
     */
    public static final SSS SSS = new SSS();

    /**
     * The table <code>sss.CATEGORY</code>.
     */
    public final Category CATEGORY = Category.CATEGORY;

    /**
     * The table <code>sss.EXPENSE</code>.
     */
    public final Expense EXPENSE = Expense.EXPENSE;

    /**
     * The table <code>sss.MONTHLY_HISTORY</code>.
     */
    public final MonthlyHistory MONTHLY_HISTORY = MonthlyHistory.MONTHLY_HISTORY;

    /**
     * The table <code>sss.RECURRING_EXPENSE</code>.
     */
    public final RecurringExpense RECURRING_EXPENSE = RecurringExpense.RECURRING_EXPENSE;

    /**
     * The table <code>sss.RESET_PASSWORD</code>.
     */
    public final ResetPassword RESET_PASSWORD = ResetPassword.RESET_PASSWORD;

    /**
     * The table <code>sss.SCHEMA_VERSION</code>.
     */
    public final SchemaVersion SCHEMA_VERSION = SchemaVersion.SCHEMA_VERSION;

    /**
     * The table <code>sss.SETTINGS</code>.
     */
    public final Settings SETTINGS = Settings.SETTINGS;

    /**
     * The table <code>sss.USER</code>.
     */
    public final User USER = User.USER;

    /**
     * The table <code>sss.YEARLY_HISTORY</code>.
     */
    public final YearlyHistory YEARLY_HISTORY = YearlyHistory.YEARLY_HISTORY;

    /**
     * No further instances allowed
     */
    private SSS() {
        super("sss", null);
    }


    @Override
    public Catalog getCatalog() {
        return DefaultCatalog.DEFAULT_CATALOG;
    }

    @Override
    public final List<Table<?>> getTables() {
        return Arrays.asList(
            Category.CATEGORY,
            Expense.EXPENSE,
            MonthlyHistory.MONTHLY_HISTORY,
            RecurringExpense.RECURRING_EXPENSE,
            ResetPassword.RESET_PASSWORD,
            SchemaVersion.SCHEMA_VERSION,
            Settings.SETTINGS,
            User.USER,
            YearlyHistory.YEARLY_HISTORY
        );
    }
}