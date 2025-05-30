/*
 * This file is generated by jOOQ.
 */
package com.ftpix.sss.dsl;


import com.ftpix.sss.dsl.tables.Category;
import com.ftpix.sss.dsl.tables.Expense;
import com.ftpix.sss.dsl.tables.FlywaySchemaHistory;
import com.ftpix.sss.dsl.tables.MonthlyHistory;
import com.ftpix.sss.dsl.tables.RecurringExpense;
import com.ftpix.sss.dsl.tables.ResetPassword;
import com.ftpix.sss.dsl.tables.Settings;
import com.ftpix.sss.dsl.tables.User;
import com.ftpix.sss.dsl.tables.YearlyHistory;

import java.util.Arrays;
import java.util.List;

import org.jooq.Catalog;
import org.jooq.Table;
import org.jooq.impl.DSL;
import org.jooq.impl.SchemaImpl;


/**
 * standard public schema
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes", "this-escape" })
public class PUBLIC extends SchemaImpl {

    private static final long serialVersionUID = 1L;

    /**
     * The reference instance of <code>public</code>
     */
    public static final PUBLIC PUBLIC = new PUBLIC();

    /**
     * The table <code>public.category</code>.
     */
    public final Category CATEGORY = Category.CATEGORY;

    /**
     * The table <code>public.expense</code>.
     */
    public final Expense EXPENSE = Expense.EXPENSE;

    /**
     * The table <code>public.flyway_schema_history</code>.
     */
    public final FlywaySchemaHistory FLYWAY_SCHEMA_HISTORY = FlywaySchemaHistory.FLYWAY_SCHEMA_HISTORY;

    /**
     * The table <code>public.monthly_history</code>.
     */
    public final MonthlyHistory MONTHLY_HISTORY = MonthlyHistory.MONTHLY_HISTORY;

    /**
     * The table <code>public.recurring_expense</code>.
     */
    public final RecurringExpense RECURRING_EXPENSE = RecurringExpense.RECURRING_EXPENSE;

    /**
     * The table <code>public.reset_password</code>.
     */
    public final ResetPassword RESET_PASSWORD = ResetPassword.RESET_PASSWORD;

    /**
     * The table <code>public.settings</code>.
     */
    public final Settings SETTINGS = Settings.SETTINGS;

    /**
     * The table <code>public.user</code>.
     */
    public final User USER = User.USER;

    /**
     * The table <code>public.yearly_history</code>.
     */
    public final YearlyHistory YEARLY_HISTORY = YearlyHistory.YEARLY_HISTORY;

    /**
     * No further instances allowed
     */
    private PUBLIC() {
        super(DSL.name("public"), null, DSL.comment("standard public schema"));
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
            FlywaySchemaHistory.FLYWAY_SCHEMA_HISTORY,
            MonthlyHistory.MONTHLY_HISTORY,
            RecurringExpense.RECURRING_EXPENSE,
            ResetPassword.RESET_PASSWORD,
            Settings.SETTINGS,
            User.USER,
            YearlyHistory.YEARLY_HISTORY
        );
    }
}
