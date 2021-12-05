/*
 * This file is generated by jOOQ.
 */
package com.ftpix.sss.dsl.tables;


import com.ftpix.sss.dsl.Keys;
import com.ftpix.sss.dsl.Sss;
import com.ftpix.sss.dsl.tables.records.ExpenseRecord;

import org.jooq.Field;
import org.jooq.ForeignKey;
import org.jooq.Identity;
import org.jooq.Name;
import org.jooq.Record;
import org.jooq.Row11;
import org.jooq.Schema;
import org.jooq.Table;
import org.jooq.TableField;
import org.jooq.TableOptions;
import org.jooq.UniqueKey;
import org.jooq.impl.DSL;
import org.jooq.impl.SQLDataType;
import org.jooq.impl.TableImpl;


/**
 * This class is generated by jOOQ.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class Expense extends TableImpl<ExpenseRecord> {

    private static final long serialVersionUID = 1L;

    /**
     * The reference instance of <code>sss.EXPENSE</code>
     */
    public static final Expense EXPENSE = new Expense();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<ExpenseRecord> getRecordType() {
        return ExpenseRecord.class;
    }

    /**
     * The column <code>sss.EXPENSE.ID</code>.
     */
    public final TableField<ExpenseRecord, Long> ID = createField(DSL.name("ID"), SQLDataType.BIGINT.nullable(false).identity(true), this, "");

    /**
     * The column <code>sss.EXPENSE.AMOUNT</code>.
     */
    public final TableField<ExpenseRecord, Double> AMOUNT = createField(DSL.name("AMOUNT"), SQLDataType.DOUBLE, this, "");

    /**
     * The column <code>sss.EXPENSE.CATEGORY_ID</code>.
     */
    public final TableField<ExpenseRecord, Long> CATEGORY_ID = createField(DSL.name("CATEGORY_ID"), SQLDataType.BIGINT, this, "");

    /**
     * The column <code>sss.EXPENSE.DATE</code>.
     */
    public final TableField<ExpenseRecord, String> DATE = createField(DSL.name("DATE"), SQLDataType.VARCHAR(50), this, "");

    /**
     * The column <code>sss.EXPENSE.TYPE</code>.
     */
    public final TableField<ExpenseRecord, Integer> TYPE = createField(DSL.name("TYPE"), SQLDataType.INTEGER, this, "");

    /**
     * The column <code>sss.EXPENSE.INCOME</code>.
     */
    public final TableField<ExpenseRecord, Byte> INCOME = createField(DSL.name("INCOME"), SQLDataType.TINYINT, this, "");

    /**
     * The column <code>sss.EXPENSE.LATITUDE</code>.
     */
    public final TableField<ExpenseRecord, Double> LATITUDE = createField(DSL.name("LATITUDE"), SQLDataType.DOUBLE, this, "");

    /**
     * The column <code>sss.EXPENSE.LONGITUDE</code>.
     */
    public final TableField<ExpenseRecord, Double> LONGITUDE = createField(DSL.name("LONGITUDE"), SQLDataType.DOUBLE, this, "");

    /**
     * The column <code>sss.EXPENSE.NOTE</code>.
     */
    public final TableField<ExpenseRecord, String> NOTE = createField(DSL.name("NOTE"), SQLDataType.CLOB, this, "");

    /**
     * The column <code>sss.EXPENSE.TIME</code>.
     */
    public final TableField<ExpenseRecord, String> TIME = createField(DSL.name("TIME"), SQLDataType.VARCHAR(5), this, "");

    /**
     * The column <code>sss.EXPENSE.TIMESTAMP</code>.
     */
    public final TableField<ExpenseRecord, Long> TIMESTAMP = createField(DSL.name("TIMESTAMP"), SQLDataType.BIGINT, this, "");

    private Expense(Name alias, Table<ExpenseRecord> aliased) {
        this(alias, aliased, null);
    }

    private Expense(Name alias, Table<ExpenseRecord> aliased, Field<?>[] parameters) {
        super(alias, null, aliased, parameters, DSL.comment(""), TableOptions.table());
    }

    /**
     * Create an aliased <code>sss.EXPENSE</code> table reference
     */
    public Expense(String alias) {
        this(DSL.name(alias), EXPENSE);
    }

    /**
     * Create an aliased <code>sss.EXPENSE</code> table reference
     */
    public Expense(Name alias) {
        this(alias, EXPENSE);
    }

    /**
     * Create a <code>sss.EXPENSE</code> table reference
     */
    public Expense() {
        this(DSL.name("EXPENSE"), null);
    }

    public <O extends Record> Expense(Table<O> child, ForeignKey<O, ExpenseRecord> key) {
        super(child, key, EXPENSE);
    }

    @Override
    public Schema getSchema() {
        return aliased() ? null : Sss.SSS;
    }

    @Override
    public Identity<ExpenseRecord, Long> getIdentity() {
        return (Identity<ExpenseRecord, Long>) super.getIdentity();
    }

    @Override
    public UniqueKey<ExpenseRecord> getPrimaryKey() {
        return Keys.KEY_EXPENSE_PRIMARY;
    }

    @Override
    public Expense as(String alias) {
        return new Expense(DSL.name(alias), this);
    }

    @Override
    public Expense as(Name alias) {
        return new Expense(alias, this);
    }

    /**
     * Rename this table
     */
    @Override
    public Expense rename(String name) {
        return new Expense(DSL.name(name), null);
    }

    /**
     * Rename this table
     */
    @Override
    public Expense rename(Name name) {
        return new Expense(name, null);
    }

    // -------------------------------------------------------------------------
    // Row11 type methods
    // -------------------------------------------------------------------------

    @Override
    public Row11<Long, Double, Long, String, Integer, Byte, Double, Double, String, String, Long> fieldsRow() {
        return (Row11) super.fieldsRow();
    }
}