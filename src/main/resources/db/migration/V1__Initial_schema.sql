CREATE TABLE category (
    id              BIGSERIAL PRIMARY KEY,
    icon            VARCHAR(255),
    category_order  INTEGER,
    user_id         VARCHAR(48)
);

CREATE TABLE expense (
    id           BIGSERIAL PRIMARY KEY,
    amount       DOUBLE PRECISION,
    category_id  BIGINT,
    date         VARCHAR(50),
    type         INTEGER,
    income       INTEGER,
    latitude     DOUBLE PRECISION,
    longitude    DOUBLE PRECISION,
    note         TEXT,
    time         VARCHAR(5),
    timestamp    BIGINT
);

CREATE TABLE monthly_history (
    id           VARCHAR(48) PRIMARY KEY,
    category_id  BIGINT,
    total        DOUBLE PRECISION,
    date         INTEGER
);

CREATE INDEX monthly_history_date_idx
    ON monthly_history (date);

CREATE UNIQUE INDEX monthly_history_unique_idx
    ON monthly_history (category_id, date);

CREATE TABLE recurring_expense (
    id               BIGSERIAL PRIMARY KEY,
    name             VARCHAR(255),
    category_id      BIGINT,
    type             INTEGER,
    type_param       INTEGER,
    last_occurrence  VARCHAR(50),
    next_occurrence  VARCHAR(50),
    amount           DOUBLE PRECISION,
    income           INTEGER
);

CREATE TABLE reset_password (
    id          VARCHAR(48) PRIMARY KEY,
    user_id     VARCHAR(48),
    expirydate  BIGINT
);

CREATE TABLE settings (
    name    VARCHAR(255) PRIMARY KEY,
    value   TEXT,
    secret  BOOLEAN DEFAULT FALSE
);

CREATE TABLE "user" (
    id                      VARCHAR(48) PRIMARY KEY,
    email                   VARCHAR(255) UNIQUE NOT NULL,
    firstname               VARCHAR(255) NOT NULL,
    password                VARCHAR(255) NOT NULL,
    lastname                VARCHAR(255) NOT NULL,
    subscriptionexpirydate  BIGINT,
    showannouncement        INTEGER,
    isadmin                 INTEGER
);

CREATE TABLE yearly_history (
    id           VARCHAR(48) PRIMARY KEY,
    category_id  BIGINT,
    total        DOUBLE PRECISION,
    date         INTEGER
);

CREATE INDEX yearly_history_date_idx
    ON yearly_history (date);

CREATE UNIQUE INDEX yearly_history_unique
    ON yearly_history (category_id, date);