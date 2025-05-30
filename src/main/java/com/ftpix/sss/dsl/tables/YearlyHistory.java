/*
 * This file is generated by jOOQ.
 */
package com.ftpix.sss.dsl.tables;


import com.ftpix.sss.dsl.Indexes;
import com.ftpix.sss.dsl.Keys;
import com.ftpix.sss.dsl.PUBLIC;
import com.ftpix.sss.dsl.tables.records.YearlyHistoryRecord;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.jooq.Condition;
import org.jooq.Field;
import org.jooq.Index;
import org.jooq.Name;
import org.jooq.PlainSQL;
import org.jooq.QueryPart;
import org.jooq.SQL;
import org.jooq.Schema;
import org.jooq.Select;
import org.jooq.Stringly;
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
@SuppressWarnings({ "all", "unchecked", "rawtypes", "this-escape" })
public class YearlyHistory extends TableImpl<YearlyHistoryRecord> {

    private static final long serialVersionUID = 1L;

    /**
     * The reference instance of <code>public.yearly_history</code>
     */
    public static final YearlyHistory YEARLY_HISTORY = new YearlyHistory();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<YearlyHistoryRecord> getRecordType() {
        return YearlyHistoryRecord.class;
    }

    /**
     * The column <code>public.yearly_history.id</code>.
     */
    public final TableField<YearlyHistoryRecord, String> ID = createField(DSL.name("id"), SQLDataType.VARCHAR(48).nullable(false), this, "");

    /**
     * The column <code>public.yearly_history.category_id</code>.
     */
    public final TableField<YearlyHistoryRecord, Long> CATEGORY_ID = createField(DSL.name("category_id"), SQLDataType.BIGINT, this, "");

    /**
     * The column <code>public.yearly_history.total</code>.
     */
    public final TableField<YearlyHistoryRecord, Double> TOTAL = createField(DSL.name("total"), SQLDataType.DOUBLE, this, "");

    /**
     * The column <code>public.yearly_history.date</code>.
     */
    public final TableField<YearlyHistoryRecord, Integer> DATE = createField(DSL.name("date"), SQLDataType.INTEGER, this, "");

    private YearlyHistory(Name alias, Table<YearlyHistoryRecord> aliased) {
        this(alias, aliased, (Field<?>[]) null, null);
    }

    private YearlyHistory(Name alias, Table<YearlyHistoryRecord> aliased, Field<?>[] parameters, Condition where) {
        super(alias, null, aliased, parameters, DSL.comment(""), TableOptions.table(), where);
    }

    /**
     * Create an aliased <code>public.yearly_history</code> table reference
     */
    public YearlyHistory(String alias) {
        this(DSL.name(alias), YEARLY_HISTORY);
    }

    /**
     * Create an aliased <code>public.yearly_history</code> table reference
     */
    public YearlyHistory(Name alias) {
        this(alias, YEARLY_HISTORY);
    }

    /**
     * Create a <code>public.yearly_history</code> table reference
     */
    public YearlyHistory() {
        this(DSL.name("yearly_history"), null);
    }

    @Override
    public Schema getSchema() {
        return aliased() ? null : PUBLIC.PUBLIC;
    }

    @Override
    public List<Index> getIndexes() {
        return Arrays.asList(Indexes.YEARLY_HISTORY_DATE_IDX, Indexes.YEARLY_HISTORY_UNIQUE);
    }

    @Override
    public UniqueKey<YearlyHistoryRecord> getPrimaryKey() {
        return Keys.YEARLY_HISTORY_PKEY;
    }

    @Override
    public YearlyHistory as(String alias) {
        return new YearlyHistory(DSL.name(alias), this);
    }

    @Override
    public YearlyHistory as(Name alias) {
        return new YearlyHistory(alias, this);
    }

    @Override
    public YearlyHistory as(Table<?> alias) {
        return new YearlyHistory(alias.getQualifiedName(), this);
    }

    /**
     * Rename this table
     */
    @Override
    public YearlyHistory rename(String name) {
        return new YearlyHistory(DSL.name(name), null);
    }

    /**
     * Rename this table
     */
    @Override
    public YearlyHistory rename(Name name) {
        return new YearlyHistory(name, null);
    }

    /**
     * Rename this table
     */
    @Override
    public YearlyHistory rename(Table<?> name) {
        return new YearlyHistory(name.getQualifiedName(), null);
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public YearlyHistory where(Condition condition) {
        return new YearlyHistory(getQualifiedName(), aliased() ? this : null, null, condition);
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public YearlyHistory where(Collection<? extends Condition> conditions) {
        return where(DSL.and(conditions));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public YearlyHistory where(Condition... conditions) {
        return where(DSL.and(conditions));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public YearlyHistory where(Field<Boolean> condition) {
        return where(DSL.condition(condition));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public YearlyHistory where(SQL condition) {
        return where(DSL.condition(condition));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public YearlyHistory where(@Stringly.SQL String condition) {
        return where(DSL.condition(condition));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public YearlyHistory where(@Stringly.SQL String condition, Object... binds) {
        return where(DSL.condition(condition, binds));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public YearlyHistory where(@Stringly.SQL String condition, QueryPart... parts) {
        return where(DSL.condition(condition, parts));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public YearlyHistory whereExists(Select<?> select) {
        return where(DSL.exists(select));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public YearlyHistory whereNotExists(Select<?> select) {
        return where(DSL.notExists(select));
    }
}
