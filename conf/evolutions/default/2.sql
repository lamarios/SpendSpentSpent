# --- !Ups

ALTER TABLE `expense` ADD `latitude` decimal(10, 5) DEFAULT NULL;
ALTER TABLE `expense` ADD `longitude` decimal(10, 5) DEFAULT NULL;

# --- !Downs

ALTER TABLE `expense` DROP `latitude`;
ALTER TABLE `longitude` DROP `latitude`;

