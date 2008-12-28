class Order < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :line_items
	has_many :payments, :through => :line_items
	has_one :order_condition
  #  has_one :address, :foreign_key => 'shipping_address_id'

  def self.generate_cust_number
    is_generated = FALSE
		while is_generated == FALSE
      rand_num = rand(10000000)
      if Order.exists?(:customer_number => "#{rand_num}")
        is_generated = FALSE
      else
        is_generated = TRUE
      end
	  end
    rand_num
  end

	def self.generate
    @customer_number = rand(10000000) unless Order.exists?(:customer_number => @customer_number.to_s)
  end

=begin
    def get_shipping_address(form_value)
        if form_value == 1
           @customer_address.shipping_address = 1
        else
           @partner_address.shipping_address = 1
        end
    end
=end

  def add_line_items_from_cart(cart)
		cart.items.each do |item|
			#li = LineItem.from_cart_item(item)
			#li.quantity.times{line_items << li}
			item.quantity.times{line_items << LineItem.new( :price => item.price,
        													                    :product_id   => item.product_id)}
			#LineItem.new(:order_id => order_id, :product_id => li.product_id )
		end
		logger.info line_items.inspect  + "These are the line items"
		#line_items
	end

	def create_customers_orders_entry(customer_id)
		sql = ActiveRecord::Base.connection();
		#sql.execute "SET autocommit=0";
		sql.begin_db_transaction
		sql.insert("INSERT INTO orders_users (user_id, order_id) VALUES (#{customer_id}, #{self.id})");
		sql.commit_db_transaction
	end

	private  #----------------------------------------------------

  def self.get_orders_and_users_details(customer_number)
    self.find_by_sql(["
			SELECT		  `users`.`id`,
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
  end

end