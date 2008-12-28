/*
MySQL Data Transfer
Source Host: localhost
Source Database: shaadigiftlist_development
Target Host: localhost
Target Database: shaadigiftlist_development
Date: 23/07/2007 03:31:14
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- View structure for v_bridegroom_details
-- ----------------------------
DROP VIEW IF EXISTS `v_bridegroom_details`;
CREATE VIEW `v_bridegroom_details` AS select `customers`.`id` AS `id`,`customers`.`first_name` AS `first_name`,`customers`.`last_name` AS `last_name`,`customers`.`date_of_birth` AS `date_of_birth`,`customers`.`email` AS `email`,`customers`.`contact_number` AS `contact_number`,`customers`.`evening_number` AS `evening_number`,`customers`.`mobile_number` AS `mobile_number`,`customers`.`customertype_id` AS `customertype_id`,`orders`.`id` AS `order_id`,`orders`.`customer_number` AS `customer_number`,`orders`.`ordercondition_id` AS `ordercondition_id` from ((`orders` join `customers_orders` on((`customers_orders`.`order_id` = `orders`.`id`))) join `customers` on((`customers`.`id` = `customers_orders`.`customer_id`)));

-- ----------------------------
-- View structure for v_bridegroom_orders
-- ----------------------------
DROP VIEW IF EXISTS `v_bridegroom_orders`;
CREATE VIEW `v_bridegroom_orders` AS select `p1`.`first_name` AS `p1_first_name`,`p2`.`first_name` AS `p2_first_name`,`p1`.`order_id` AS `order_id`,`p1`.`customer_number` AS `customer_number`,`p1`.`id` AS `p1_id`,`p2`.`id` AS `p2_id`,`p1`.`last_name` AS `p1_last_name`,`p2`.`last_name` AS `p2_last_name` from (`v_bridegroom_details` `p1` join `v_bridegroom_details` `p2` on(((`p1`.`order_id` = `p2`.`order_id`) and (`p1`.`id` <> `p2`.`id`)))) group by `p1`.`order_id` order by `p1`.`order_id`;

-- ----------------------------
-- View structure for v_customer_address
-- ----------------------------
DROP VIEW IF EXISTS `v_customer_address`;
CREATE VIEW `v_customer_address` AS select `customers`.`id` AS `id`,`customers`.`first_name` AS `first_name`,`customers`.`last_name` AS `last_name`,`customers`.`date_of_birth` AS `date_of_birth`,`customers`.`email` AS `email`,`customers`.`contact_number` AS `contact_number`,`customers`.`evening_number` AS `evening_number`,`customers`.`mobile_number` AS `mobile_number`,`customers`.`created_at` AS `created_at`,`customers`.`updated_at` AS `updated_at`,`customers`.`customertype_id` AS `customertype_id`,`addresses`.`line_one` AS `line_one`,`addresses`.`line_two` AS `line_two`,`addresses`.`line_three` AS `line_three`,`addresses`.`city` AS `city`,`addresses`.`county` AS `county`,`addresses`.`country` AS `country`,`addresses`.`post_code` AS `post_code`,`addresses`.`updated_at` AS `address_updated_at`,`addresses`.`created_at` AS `address_created_at` from ((`addresses` join `addresses_customers` on((`addresses_customers`.`address_id` = `addresses`.`id`))) join `customers` on((`customers`.`id` = `addresses_customers`.`customer_id`)));

-- ----------------------------
-- Records 
-- ----------------------------
