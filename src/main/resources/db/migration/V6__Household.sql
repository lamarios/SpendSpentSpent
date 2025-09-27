create table household
(
    id varchar(55) primary key default gen_random_uuid()
);

create table household_members
(
    id            varchar(55) primary key default gen_random_uuid(),

    user_id       VARCHAR(55),
    CONSTRAINT fk_household_user FOREIGN KEY (user_id)
        REFERENCES "user" (id)
        ON DELETE CASCADE,
    invited_by_id VARCHAR(55),
    CONSTRAINT fk_household_invited_by FOREIGN KEY (invited_by_id)
        REFERENCES "user" (id),
    status        varchar(55) not null,
    admin         boolean                 default false,
    color         varchar(55) not null,
    household_id  VARCHAR(55),
    CONSTRAINT fk_household foreign key (household_id)
        references household (id) on delete cascade
);