CREATE VIEW `shaadigiftlist_development`.`bridegroomdetails` AS
	SELECT			`customers`.`id`,
							`customers`.`first_name`,
							`customers`.`last_name`,
							`customers`.`customer_type_id`,
							`orders`.`id` as `order_id`,
							`orders`.`customer_number`
	FROM				`orders`
	INNER JOIN	`customers_orders` ON `customers_orders`.`order_id` = `orders`.`id`
	INNER JOIN	`customers` ON `customers`.`id` = `customers_orders`.`customer_id`