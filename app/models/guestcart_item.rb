class GuestcartItem

	attr_writer(:name, :image_url, :line_item_id, :price, :customer_ip, :product_id)
	attr_reader(:name, :image_url, :line_item_id, :price, :customer_ip, :product_id)
	
	def initialize(name, line_item_id, product_id, price, image_url)
		@line_item_id = line_item_id
		@image_url = image_url
		@price = price
		@name = name
		@product_id = product_id
	end

end
