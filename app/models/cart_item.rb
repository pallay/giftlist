class CartItem
	
	attr_reader :product_id, :quantity, :product
  attr_writer :product_id

	def initialize(product)
		@product = product
		@product_id = product.id # <-- added as part of cart drag and drop
		@quantity = 1
	end
	
	def increment_quantity
		@quantity += 1
	end

	def decrement_quantity
		if @quantity > 1
			@quantity -= 1
		else
			@quantity = 0
		end
		@quantity
	end

	def name
		@product.name
	end
	
	def price
		@product.price * @quantity
  end
    
  def product_id
    @product.id
	end

end