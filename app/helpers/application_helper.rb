# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def number_to_pound(number)
		number_to_currency(number, :unit => "&pound;", :seperator => ",", :delimiter => "")
	end

  def format_date(date)
    h date.strftime('%a the %d of %B %Y').gsub(/(\d+)/) { |s| s.to_i < 31?s.to_i.ordinalize : s }
  end

	def remove_item_link(text, item)
	 	link_to_remote text,
	 	{:url => {:controller => "guest", :action => "remove", :id => item}},
		{ :title => "Remove purchase",
	    :href => url_for(:controller => "guest", :action => "remove", :id => item)}
	end

#	def clear_guestcart_link(text = "Clear your purchases")
# 		link_to_remote text,
# 		{:url => {:controller => "guestcart", :action => "clear"}},
#		{:href => url_for(:controller => "guestcart", :action => "clear")}
#	end

	def remove_item_link2(text, item)
	 	link_to_remote text,
	 	{:url => {:controller => "giftlists", :action => "remove_product", :id => item}},
		{ :title => "Remove from Gift List",
      :href => url_for(	:controller => "giftlists", :action => "remove_product", :id => item)}
	end

	def remove_item_link3(text, item)
	 	link_to_remote text,
	 	{:url => {:controller => "dashboard", :action => "remove_from_cart", :id => item}},
		{ :title => "Remove from Gift List",
      :href => url_for(	:controller => "dashboard", :action => "remove_from_cart", :id => item)}
	end

#	def remove_item_link3(text, item, row_id)
#	 	link_to text,
#	 	{:url => {:controller => "giftlists", :action => "remove_product", :id => item} },
#		{ :title => "Remove from Gift List",
#		  :href => url_for(	:controller => "giftlists", :action => "remove_product", :id => item),
#			:onclick => "removeProductFromList(\"#{row_id}\",\" giftlist/remove_product/#{item}\"); return false;"}
#	end
	
	private #-------------------------------------------------------

	def redirect_to_index(msg = nil)
		flash[:notice] = msg if msg
		redirect_to :action => :index
	end

end