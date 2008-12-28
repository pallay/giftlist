/* ALGORITHM=UNDEFINED */
select		`shaadigiftlist_development`.`customers`.`id` AS `id`,
					`shaadigiftlist_development`.`customers`.`first_name` AS `first_name`,
					`shaadigiftlist_development`.`customers`.`last_name` AS `last_name`,
					`shaadigiftlist_development`.`customers`.`date_of_birth` AS `date_of_birth`,
					`shaadigiftlist_development`.`customers`.`email` AS `email`,
					`shaadigiftlist_development`.`customers`.`contact_number` AS `contact_number`,
					`shaadigiftlist_development`.`customers`.`evening_number` AS `evening_number`,
					`shaadigiftlist_development`.`customers`.`mobile_number` AS `mobile_number`,
					`shaadigiftlist_development`.`customers`.`created_at` AS `created_at`,
					`shaadigiftlist_development`.`customers`.`updated_at` AS `updated_at`,
					`shaadigiftlist_development`.`customers`.`customertype_id` AS `customertype_id`,
					`shaadigiftlist_development`.`addresses`.`line_one` AS `line_one`,
					`shaadigiftlist_development`.`addresses`.`line_two` AS `line_two`,
					`shaadigiftlist_development`.`addresses`.`line_three` AS `line_three`,
					`shaadigiftlist_development`.`addresses`.`city` AS `city`,
					`shaadigiftlist_development`.`addresses`.`county` AS `county`,
					`shaadigiftlist_development`.`addresses`.`country` AS `country`,
					`shaadigiftlist_development`.`addresses`.`post_code` AS `post_code`,
					`shaadigiftlist_development`.`addresses`.`updated_at` AS `address_updated_at`,
					`shaadigiftlist_development`.`addresses`.`created_at` AS `address_created_at`
from (
			(`shaadigiftlist_development`.`addresses`
				join `shaadigiftlist_development`.`addresses_customers`
			 on(
					(`shaadigiftlist_development`.`addresses_customers`.`address_id` = `shaadigiftlist_development`.`addresses`.`id`)
					)
			 )
			 join `shaadigiftlist_development`.`customers`
			on(
				(`shaadigiftlist_development`.`customers`.`id` = `shaadigiftlist_development`.`addresses_customers`.`customer_id`)
			)
)