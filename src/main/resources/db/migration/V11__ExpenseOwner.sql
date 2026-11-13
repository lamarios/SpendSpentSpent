-- Expenses and recurring expenses used to belong to a user only through their category.
-- Categories are now shared within a household, so we store who created each entry.
-- Columns stay nullable so older versions (which don't know about them) can still insert rows;
-- the application backfills missing values on startup.

ALTER TABLE expense
    ADD COLUMN user_id VARCHAR(55);
ALTER TABLE expense
    ADD CONSTRAINT fk_expense_user FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE;

ALTER TABLE recurring_expense
    ADD COLUMN user_id VARCHAR(55);
ALTER TABLE recurring_expense
    ADD CONSTRAINT fk_recurring_expense_user FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE;

UPDATE expense e
SET user_id = c.user_id
FROM category c
WHERE e.category_id = c.id;

UPDATE recurring_expense r
SET user_id = c.user_id
FROM category c
WHERE r.category_id = c.id;

CREATE INDEX expense_user_id_idx ON expense (user_id);
CREATE INDEX recurring_expense_user_id_idx ON recurring_expense (user_id);
