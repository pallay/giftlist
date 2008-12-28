class LineItem < ActiveRecord::Base
	
	belongs_to		:order
	belongs_to  	:customer
	has_one			  :product, :foreign_key => 'id' #got to join with the products table via id AND NOT line_item_id
	has_one			  :payment
  acts_as_list	:scope => :order

	def self.from_cart_item(cart_item)		
		li = self.new
		li.price    	= cart_item.price
    li.product_id = cart_item.product_id
		@quantity		  = cart_item.quantity
    li
	end

  def self.get_lineitems_and_products_details(giftlist_order_id)
    self.find_by_sql(["
		  SELECT	    `line_items`.`id`,
						      `line_items`.`product_id`,
						      `line_items`.`order_id`,
						      `products`.`id`,
						      `products`.`image_url`,
						      `products`.`name`,
						      `products`.`category`,
						      `products`.`price`
			FROM	      `line_items`
			INNER JOIN	`products` ON `line_items`.`product_id` = `products`.`id`
			WHERE       `line_items`.`order_id` = ?", giftlist_order_id
		])
  end

  def self.get_line_item_details(order_id)
    self.find_by_sql(["
			SELECT		  `line_items`.`id`,
						      `line_items`.`order_id`,
						      `products`.`id` as product_id,
						      `products`.`image_url`,
						      `products`.`name`,
						      `products`.`category`,
						      `products`.`price`
			FROM	  	  `line_items`
			INNER JOIN	`products` ON `line_items`.`product_id` = `products`.`id`
			WHERE       `line_items`.`order_id` = ?", order_id
		])
  end

  def self.get_line_item_details2(line_item_id)
    self.find_by_sql(["
			SELECT		  `products`.`name`,
						      `products`.`image_url`,
						      `products`.`price`,
                  `line_items`.`id` AS line_item_id,
						      `line_items`.`product_id`,
						      `line_items`.`order_id`
			FROM	    	`line_items`
			INNER JOIN	`products` ON `line_items`.`product_id` = `products`.`id`
			WHERE	  	  `bought` = 0 AND `line_items`.`id` = ?", line_item_id
		])
  end

end