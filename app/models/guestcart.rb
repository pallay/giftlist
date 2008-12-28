class Guestcart

#	has_many    :guestcar_titems
#	has_many    :products, :through => :guestcart_items
# belongs_to  :customer

	attr_reader :items

	def initialize()
		@items = []
	end

	def add_item(item)
		@items << item
	end

	def has_line_item_id(guestcart_item, line_item_id)
		return guestcart_item.line_item_id = line_item_id
	end

	def remove_item(line_item_id)
#		@items.each do |guestcart_lineitem|
#		  if guestcart_lineitem.line_item_id = line_item_id ? @items.delete(guestcart_lineitem) : false
#			end
#		end
    @items.each do |guestcart_item|
      if has_line_item_id(guestcart_item, line_item_id)
				@items.delete(guestcart_item)
				return true
			end
		  return false
	  end
	end

	def has_item(line_item_id)
		@items.each do |guestcart_item|
			if has_line_item_id(guestcart_item, line_item_id)  
				return true
			end
		end
		return false
	end

	def total_price
		@items.sum {|item| item.price.to_i}	#	(items.inject(0) {|sum, n| n.price + sum}).to_i
	end

end