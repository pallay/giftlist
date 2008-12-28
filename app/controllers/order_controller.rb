class OrderController < ApplicationController
  
	def list
		@orders = Order.find(:all)
		@page_title = 'Listing all orders'
	end
	
end
