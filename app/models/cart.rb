class Cart

	attr_reader :items

	def initialize
		@items = []
	end

	def add_product(product)
		current_item = @items.find {|item| item.product == product}
		if current_item
			current_item.increment_quantity
		else
			current_item = CartItem.new(product)
			@items << current_item
		end
		current_item
	end

  def remove_product(product)
  	current_item = @items.find {|item| item.product == product}
		removed_item = current_item.dup
  	if current_item.quantity > 1
      current_item.decrement_quantity
    else
  		@items.delete(current_item)
  	end
  	removed_item
  end

	def has_product_id(item, product_id)
		return item.product_id = product_id
	end

	def has_item(product_id)
		@items.each do |item|
			if has_product_id(item, product_id)  
				return true
			end
		end
		return false
	end

	def total_items
		@items.sum {|item| item.quantity}
	end

	def total_price
		@items.sum {|item| item.price}
	end

end
