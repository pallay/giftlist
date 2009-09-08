class Giftlist

  def self.get_orders_and_bridegrooms_details(customer_number)
    Order.find_by_sql(["
			SELECT  		`users`.`id`,
						      `users`.`first_name`,
						      `users`.`last_name`,
						      `users`.`date_of_birth`,
						      `users`.`email`,
						      `users`.`contact_number`,
						      `users`.`evening_number`,
						      `users`.`mobile_number`,
						      `orders_users`.`user_id`,
						      `orders_users`.`order_id`,
						      `orders`.`id`,
						      `orders`.`customer_number`,
						      `orders`.`order_condition_id`
			FROM		    `orders`
			INNER JOIN	`orders_users` ON `orders_users`.`order_id` = `orders`.`id`
			INNER JOIN	`users` ON `users`.`id` = `orders_users`.`user_id`
			WHERE		    `orders`.`customer_number` = ?", customer_number
		])
	#  					      `permissions`.`role_id`,
  #						      `permissions`.`user_id`,
	#	INNER JOIN	`permissions` ON `users`.`id` = `permissions`.`user_id`
  end

end
