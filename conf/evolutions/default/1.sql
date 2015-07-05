 
# --- !Ups
 
CREATE TABLE `category` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `icon` varchar(50) NOT NULL DEFAULT '',
  `category_order` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
);
 
 
 CREATE TABLE `expense` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) DEFAULT NULL,
  `category_id` bigint(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `income` tinyint(1) DEFAULT NULL,
  `type` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ;


CREATE TABLE `recurring_expense` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `category_id` bigint(11) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `type_param` int(2) DEFAULT NULL,
  `last_occurrence` date DEFAULT NULL,
  `next_occurrence` date DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `income` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `user_session`(
  `token` varchar(50) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  PRIMARY KEY (`token`)
);


CREATE TABLE `setting` (
  `name` varchar(50) DEFAULT NULL,
  `value` varchar(250) DEFAULT NULL,
   PRIMARY KEY (`name`)
);


CREATE SEQUENCE	 IF NOT EXISTS	`category_sequence` START WITH 0;
CREATE SEQUENCE	 IF NOT EXISTS	`expense_sequence` START WITH 0;
CREATE SEQUENCE	 IF NOT EXISTS	`recurring_sequence` START WITH 0;
# --- !Downs
 
DROP TABLE `category`;
DROP TABLE `expense`;
DROP TABLE `recurring_expense`;
DROP TABLE `setting`;
DROP TABLE `user_session`;

DROP SEQUENCE `category_sequence`;
DROP SEQUENCE `expense_sequence`;
DROP SEQUENCE `recurring_sequence`;