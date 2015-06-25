 
# --- !Ups
 
CREATE TABLE `category` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `icon` varchar(50) NOT NULL DEFAULT '',
  `category_order` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=latin1;
 
 
 CREATE TABLE `expense` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) DEFAULT NULL,
  `category_id` bigint(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `income` tinyint(1) DEFAULT NULL,
  `type` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
)  DEFAULT CHARSET=latin1;


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
) DEFAULT CHARSET=latin1;
# --- !Downs
 
DROP TABLE `category`;
DROP TABLE `expense`;
DROP TABLE `recurring_expense`;