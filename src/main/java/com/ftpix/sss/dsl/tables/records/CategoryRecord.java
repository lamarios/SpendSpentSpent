/*
 * This file is generated by jOOQ.
 */
package com.ftpix.sss.dsl.tables.records;


import com.ftpix.sss.dsl.tables.Category;

import org.jooq.Field;
import org.jooq.Record1;
import org.jooq.Record4;
import org.jooq.Row4;
import org.jooq.impl.UpdatableRecordImpl;


/**
 * This class is generated by jOOQ.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class CategoryRecord extends UpdatableRecordImpl<CategoryRecord> implements Record4<Long, String, Integer, String> {

    private static final long serialVersionUID = 1L;

    /**
     * Setter for <code>sss.CATEGORY.ID</code>.
     */
    public void setId(Long value) {
        set(0, value);
    }

    /**
     * Getter for <code>sss.CATEGORY.ID</code>.
     */
    public Long getId() {
        return (Long) get(0);
    }

    /**
     * Setter for <code>sss.CATEGORY.ICON</code>.
     */
    public void setIcon(String value) {
        set(1, value);
    }

    /**
     * Getter for <code>sss.CATEGORY.ICON</code>.
     */
    public String getIcon() {
        return (String) get(1);
    }

    /**
     * Setter for <code>sss.CATEGORY.CATEGORY_ORDER</code>.
     */
    public void setCategoryOrder(Integer value) {
        set(2, value);
    }

    /**
     * Getter for <code>sss.CATEGORY.CATEGORY_ORDER</code>.
     */
    public Integer getCategoryOrder() {
        return (Integer) get(2);
    }

    /**
     * Setter for <code>sss.CATEGORY.USER_ID</code>.
     */
    public void setUserId(String value) {
        set(3, value);
    }

    /**
     * Getter for <code>sss.CATEGORY.USER_ID</code>.
     */
    public String getUserId() {
        return (String) get(3);
    }

    // -------------------------------------------------------------------------
    // Primary key information
    // -------------------------------------------------------------------------

    @Override
    public Record1<Long> key() {
        return (Record1) super.key();
    }

    // -------------------------------------------------------------------------
    // Record4 type implementation
    // -------------------------------------------------------------------------

    @Override
    public Row4<Long, String, Integer, String> fieldsRow() {
        return (Row4) super.fieldsRow();
    }

    @Override
    public Row4<Long, String, Integer, String> valuesRow() {
        return (Row4) super.valuesRow();
    }

    @Override
    public Field<Long> field1() {
        return Category.CATEGORY.ID;
    }

    @Override
    public Field<String> field2() {
        return Category.CATEGORY.ICON;
    }

    @Override
    public Field<Integer> field3() {
        return Category.CATEGORY.CATEGORY_ORDER;
    }

    @Override
    public Field<String> field4() {
        return Category.CATEGORY.USER_ID;
    }

    @Override
    public Long component1() {
        return getId();
    }

    @Override
    public String component2() {
        return getIcon();
    }

    @Override
    public Integer component3() {
        return getCategoryOrder();
    }

    @Override
    public String component4() {
        return getUserId();
    }

    @Override
    public Long value1() {
        return getId();
    }

    @Override
    public String value2() {
        return getIcon();
    }

    @Override
    public Integer value3() {
        return getCategoryOrder();
    }

    @Override
    public String value4() {
        return getUserId();
    }

    @Override
    public CategoryRecord value1(Long value) {
        setId(value);
        return this;
    }

    @Override
    public CategoryRecord value2(String value) {
        setIcon(value);
        return this;
    }

    @Override
    public CategoryRecord value3(Integer value) {
        setCategoryOrder(value);
        return this;
    }

    @Override
    public CategoryRecord value4(String value) {
        setUserId(value);
        return this;
    }

    @Override
    public CategoryRecord values(Long value1, String value2, Integer value3, String value4) {
        value1(value1);
        value2(value2);
        value3(value3);
        value4(value4);
        return this;
    }

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    /**
     * Create a detached CategoryRecord
     */
    public CategoryRecord() {
        super(Category.CATEGORY);
    }

    /**
     * Create a detached, initialised CategoryRecord
     */
    public CategoryRecord(Long id, String icon, Integer categoryOrder, String userId) {
        super(Category.CATEGORY);

        setId(id);
        setIcon(icon);
        setCategoryOrder(categoryOrder);
        setUserId(userId);
    }
}