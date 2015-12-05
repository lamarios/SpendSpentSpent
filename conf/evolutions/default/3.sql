# --- !Ups

ALTER TABLE `expense` ALTER COLUMN `latitude` SET DEFAULT 0;
ALTER TABLE `expense` ALTER COLUMN `longitude` SET DEFAULT 0;


UPDATE `expense` SET `latitude` = 0, `longitude` = 0;

# --- !Downs

ALTER TABLE `expense` DROP COLUMN `latitude`;
ALTER TABLE `expense` DROP COLUMN `longitude`;

