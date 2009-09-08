class GuestController < ApplicationController

	layout 'guest'

  before_filter :check_if_customer_search_conducted
	before_filter :find_guestcart

	def index
	  page_details
	end

  def show_by_customer_number
    page_details
    render :action => 'index'
  end

  def page_details
		@page_title = "Welcome to " + session[:bride_name] + " & " + session[:groom_name] + "'s Shaadi Gift List"
		@line_items = LineItem.find(:all, :conditions => {:order_id => session[:order_id]})
    wedding_details = WeddingDetails.find(:first, :conditions => {:user_id => session[:bride_id]})
		@image_url = wedding_details.image_url
		session[:guestcart] ||= nil    
  end

	def add
		items_from_guestcart ||= LineItem.get_line_item_details2(params[:id])
		if items_from_guestcart
			items_from_guestcart.each do |item|
			  new_guestcartitem = GuestcartItem.new(item.name, item.line_item_id, item.product_id, item.price, item.image_url)
  			@current_item = session[:guestcart].add_item(new_guestcartitem)
      end
			if request.xhr?
  		  flash.now[:guestcart_notice] = "Product added"
			elsif request.post?
				flash[:guestcart_notice] = "Product added"
			end
			redirect_to :action => "index" unless request.xhr?
		else
		  render
			logger.info "Broke, can't add item to guestcart coz doesnt exist in lineitems!"
		end
	end

	def remove
		@lineitem_to_remove = params[:id]
		@current_item = LineItem.find(@lineitem_to_remove)
		session[:guestcart].remove_item(params[:id])
		if request.xhr?
		  flash.now[:guestcart_notice] = "Product removed"
    elsif request.post?
		  flash[:guestcart_notice] = "Product removed"
	  else
	    render
	  end
	  redirect_to :controller => "index" unless request.xhr?
	end

  #	def remove
  #    	#item.total
  #		if request.xhr?
  #			flash.now[:guestcart_notice] = "Deleted <em>#{item.product.name}</em>"
  #			@line_item_to_remove = params[:id]
  #			if session[:guestcartitems].remove_item(params[:id]) then
  #				flash.now[:guestcart_notice] = "Deleted <em>#{params[:id]}</em>"
  #				render :action => "remove_with_ajax"
  #			end
  #		elsif request.post?
  #			flash[:guestcart_notice] = "Deleted <em>#{item.product.name}</em>"
  #			redirect_to :controller => "gsuest"
  #		else
  #			render
  #		end
  #	end

## Check if javascript for AJAX
=begin
	if request.xhr?
		@guestcartitem = @guestcart.add(params[:id])
		flash.now[:guestcart_notice] = "Added <em>#{@guestcartitem.product.name}</em>"
		render :action =>"add_with_ajax"
	elsif request.post?
		@guestcartitem = @guestcart.add(params[:id])
		redirect_to session[:return_to] ||{:controller => "guest"}
	else
		render
	end
=end

## Code without any javascript stuff
=begin
if request.post?
			#without the sql_find_by:
			#thisitem = LineItem.find(:first, :conditions => {:id => params[:id], :bought => 0})
			thisitem = LineItem.find_by_sql(["
				SELECT		`products`.`name`,
							`products`.`image_url`,
							`products`.`price`,
							`line_items`.`id`,
							`line_items`.`product_id`,
							`line_items`.`order_id`
				FROM		`line_items`
				INNER JOIN	`products` ON `line_items`.`product_id` = `products`.`id`
				WHERE		`bought` = 0 AND `line_items`.`id` = ?", params[:id]])
 	        	if !thisitem.nil?
					thisitem.each do |item|
						session[:guestcartitems].add_item(Guestcartitem.new(item.name, item.id, item.product_id, item.price, item.image_url))
						flash[:guestcart_notice] = "Added <em>#{item.product.name}</em>"
						#item.total
					end
				#logger.info "##########" + thisitem[0].to_s + thisitem[1].to_s + thisitem[2].to_s.to_s + thisitem[3].to_s.to_s
				#session[:guestcartitems].add_item(Guestcartitem.new(thisitem.product.name, thisitem.id, thisitem.product_id, thisitem.product.price, thisitem.product.image_url))
				##logger.info "##########" + thisitem.id.to_s + thisitem.product.name.to_s + thisitem.product.price.to_s + thisitem.product.image_url.to_s
				else
					logger.info "########## Broke, this item is nil"
				end
			redirect_to :controller => "guest"
		else
			render
		end
=end

  private #-----------------------------------------------

  def check_if_customer_search_conducted
    if session[:wedding_venue].nil?
      redirect_to :controller => 'giftlists'
      flash[:error] = 'Please do a search for the happy couple first'
    end
  end

	def find_guestcart
	  session[:guestcart] ||= Guestcart.new
  end

end
