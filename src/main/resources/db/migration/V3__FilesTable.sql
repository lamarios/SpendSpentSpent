CREATE TABLE files (
    id           VARCHAR(55) PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign key to user(id), not nullable, delete file if user is deleted
    user_id      VARCHAR(55) NOT NULL,
    CONSTRAINT fk_sss_file_user FOREIGN KEY (user_id)
        REFERENCES "user" (id)
        ON DELETE CASCADE,

    -- Foreign key to expense(id), nullable, delete file if expense is deleted
    expense_id   BIGINT,
    CONSTRAINT fk_sss_file_expense FOREIGN KEY (expense_id)
        REFERENCES expense (id)
        ON DELETE CASCADE,

    -- Enum for status (you need to create enum type first)
    status       VARCHAR(50),

    -- Free-form AI tags
    ai_tags      TEXT,
    amounts      TEXT,

    file_name    TEXT,

    -- Unix timestamps
    time_created BIGINT      NOT NULL,
    time_updated BIGINT      NOT NULL
);
