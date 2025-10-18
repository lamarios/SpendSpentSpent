create table api_keys
(
    id          varchar(55) primary key default gen_random_uuid(),
    keyName     varchar(55),
    user_id     VARCHAR(55),

    CONSTRAINT fk_api_key_user FOREIGN KEY (user_id)
        REFERENCES "user" (id)
        ON DELETE CASCADE,
    timeCreated bigint not null,
    lastUsed    bigint null,
    expiryDate  bigint null,
    apiKey      Text   not null,
    apiKeyHash  Text   not null
);

CREATE UNIQUE INDEX unique_api_key ON api_keys (apiKey);
CREATE INDEX api_keys_hash on api_keys(apiKeyHash);


