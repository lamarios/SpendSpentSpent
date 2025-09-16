ALTER TABLE category
    ADD CONSTRAINT fk_Category_user FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE;
ALTER TABLE expense
    ADD CONSTRAINT fk_expense_category FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE;
ALTER TABLE recurring_expense
    ADD CONSTRAINT fk_recurring_expense_category FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE;
ALTER TABLE monthly_history
    ADD CONSTRAINT fk_monthly_history_category FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE;
ALTER TABLE yearly_history
    ADD CONSTRAINT fk_yearly_history_category FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE;
CREATE INDEX expense_category_time on expense (category_id, "timestamp");
