class GiftlistsController < ApplicationController

	before_filter :find_cart

  auto_complete_for :product, :name

  def index
		@page_title = "List of All Brides and Grooms"
  	session[:customer_number] ||= nil
    session[:bride_id] ||= nil
	  session[:groom_id] ||= nil
    session[:bride_name] ||= nil
	  session[:groom_name] ||= nil
	  session[:wedding_venue] ||= nil
	  session[:image_url] ||= nil
  end
    
	def search
		@page_title = "Search for a Bride or Groom by Gift List Number"
		session[:customer_number] = nil
		if (params[:customer_number_search].to_s.size > 7 || params[:customer_number_search].to_s.size < 7)
			flash.now[:error] = "You need to enter a valid seven-digit number. You entered " + params[:customer_number_search].to_s + "."
			redirect_to :action => 'index'
		else
 	    #@giftlist = Giftlist.get_orders_and_bridegrooms_details(params[:customer_number_search])
      order = Order.find(:first, :conditions => ['customer_number = ?', params[:customer_number_search]])
			if order
				flash.now[:notice] = "We've found the Bride and Groom!"
    		session[:order_id] = order.id
			  bride_id = order.users[0].id
			  groom_id = order.users[1].id
        @bride = User.find_by_id(bride_id)
        @groom = User.find_by_id(groom_id)
			  bride_wedding_details = WeddingDetails.find_by_user_id(bride_id)
			  groom_wedding_details = WeddingDetails.find_by_user_id(groom_id) 
			  @groom_image = groom_wedding_details.image_url
			  @bride_image = bride_wedding_details.image_url
    		session[:customer_number] = params[:customer_number_search]	  
        session[:bride_id] = bride_id
    	  session[:groom_id] = groom_id
        session[:bride_name] = @bride.first_name.capitalize
    	  session[:groom_name] = @groom.first_name.capitalize
    	  session[:wedding_venue] = bride_wedding_details.venue
    	  session[:image_url] = bride_wedding_details.image_url.to_s	  
			else
				flash.now[:error] = "Sorry. We could not find any Brides or Grooms matching that number."
				redirect_to :action => 'index'
      end
    end
	end

  def advanced_search
		@page_title = "Search by Wedding Venue and Wedding Date"
		session[:customer_number] = nil
		if params[:wedding_venue_search].empty?
			flash[:error] = "You need to enter a valid wedding venue and wedding date."
			redirect_to :action => 'index'
		elsif (params[:wedding_venue_search])
      @wedding_details = WeddingDetails.find(:all, :conditions => ['venue = ?', params[:wedding_venue_search] ])
			unless @wedding_details.empty?
				flash[:notice] = "We've found the Bride and Groom!"
				@bride = User.find(@wedding_details[0].user_id)
        @groom = User.find(@wedding_details[1].user_id)
    		session[:customer_number] = params[:customer_number_search]	  
        session[:bride_id] = @bride.id
    	  session[:groom_id] = @groom.id
        session[:bride_name] = @bride.first_name.capitalize
    	  session[:groom_name] = @groom.first_name.capitalize
    	  session[:wedding_venue] = params[:wedding_venue_search]
    	  session[:image_url] = @wedding_details[1].image_url.to_s
      else
  			flash[:error] = "Sorry. We could not find any Brides or Grooms matching those details. You entered " + params[:wedding_venue_search].to_s + "."
  			redirect_to :action => 'index'
      end
    end
	end

# This is with the wedding date search

#  def advanced_search
#		@page_title = "Search by Wedding Venue and Wedding Date"
#		session[:customer_number] = nil
#		if params[:wedding_venue_search].empty? || params[:wedding_date_search].empty?
#			flash[:error] = "You need to enter a valid wedding venue and wedding date."
#			redirect_to :action => 'index'
#		elsif (params[:wedding_venue_search] && params[:wedding_date_search])
#      @wedding_details = WeddingDetails.find(:all, :conditions => ['venue = ? AND wedding_date = ?', params[:wedding_venue_search], params[:wedding_venue_search] ])
#			unless @wedding_details.empty?
#				flash[:notice] = "We've found the Bride and Groom!"
#				@bride = User.find(@wedding_details[0].user_id)
#        @groom = User.find(@wedding_details[1].user_id)
#        add_info_into_session2
#     		#session[:order_id] = order.id
#      else
#  			flash[:error] = "Sorry. We could not find any Brides or Grooms matching those details. You entered " + params[:wedding_venue_search].to_s + params[:wedding_date_search].to_s + "."
#  			redirect_to :action => 'index'
#      end
#    end
#	end

  def new
		@page_title = 'Create your Shaadi Gift List'
	  unless params[:search].nil?  
	    @search = params[:search]
      criteria = '%' + params[:search] + '%'
      @products = Product.find(:all, :conditions => ["name like ? OR description like ?", criteria, criteria], :order => 'created_at desc').paginate(:page => params[:page], :page_count => 6)
	    params[:search] = nil
    else
		  @products = Product.find_products_for_sale.paginate(:per_page => 6, :page => params[:page])
    end
    session[:acart] ||= []
	end

  def empty
		session[:cart] = nil
		redirect_to :action => :new unless request.xhr?
  end

	def add_product
		begin
      product_id = params[:id].split("_")[1]
      product = Product.find(product_id)
		rescue ActiveRecord::RecordNotFound
			logger.error("Attempt to access invalid product #{params[:id]}")
			redirect_to_index("Invalid product")
		else
  		if request.xhr?
  			flash.now[:cart_notice] = "Added #{product.name}"
  		elsif request.post?
  			flash[:cart_notice] = "Added #{product.name}"
  		end
			@current_item = @cart.add_product(product)
      #  session[:cart][product_id] = session[:cart].has_item(product_id) ? session[:cart][product_id] + 1 : 1
  		redirect_to :action => 'new' unless request.xhr?
#      render :partial => 'cart2'
		end
	end

	def remove_product
    #product_id = params[:id].split("_")[2]
		#product = Product.find(product_id)
		product = Product.find(params[:id])
		if request.xhr?
			flash.now[:cart_notice] = "Removed #{product.name}"
		elsif
			flash[:cart_notice] = "Removed #{product.name}"
		end
		@current_item = @cart.remove_product(product)
    #if session[:cart][product_id] > 1 
    #  session[:cart][product_id] = session[:cart][product_id] - 1
    #else
    #  session[:cart].delete(product_id)
    #end
		redirect_to :action => 'new' unless request.xhr?
    #render :partial => 'cart2'
	end

 	def show_product
		@product = Product.find(params[:id])
	end

  def details
    @customer = User.new
    @partner = User.new
    @customer_address = Address.new
    @partner_address = Address.new
    @wedding_details_customer = WeddingDetails.new
		@wedding_details_partner = WeddingDetails.new
	end

  def save
		@security_question = 2
		@customer = User.new(params[:customer])
    @partner = User.new(params[:partner])
    @customer_address = @customer.addresses.build(params[:customer_address])
    @partner_address = @partner.addresses.build(params[:partner_address])
    @wedding_details_customer = WeddingDetails.new(params[:wedding_details])
		@wedding_details_partner = WeddingDetails.new(params[:wedding_details])
		@order = Order.new
		@customer.orders << @order
		#if @customer.roles.role_name = 'groom'
		#   @partner.roles.role_name = 'bride'
		#else
		#   @partner.roles.role_name = 'groom'
		#end
		if (@customer.valid? &&
			@partner.valid? &&
			@customer_address.valid? &&
			@partner_address.valid? &&
			@wedding_details_customer.valid? &&
			@wedding_details_partner.valid?)
			@customer.save
			@partner.save
			@customer_address.save
			@partner_address.save
			@wedding_details_customer.save
			@wedding_details_partner.save
			@order.save
			update_datebase
    else
      render :action => 'details'
    end
  end

  def	update_datebase
		if params[:shipping_address] == 1
			@order.shipping_address_id = @customer_address.id
		else
			@order.shipping_address_id = @partner_address.id
		end
		@cart = find_cart
		@wedding_details_customer.update_attributes(:user_id => @customer.id)
		@wedding_details_partner.update_attributes(:user_id => @partner.id)
		@order.update_attributes(:customer_number => Order.generate_cust_number, :order_condition_id => '3') # 'opened'
		@order.create_customers_orders_entry(@partner.id)
    @order.add_line_items_from_cart(@cart)
		session[:customer_id] = @customer.id
    if @order.save!
			bridegroom_giftlistitems = LineItem.find(:all, :conditions => "order_id = @order.id")
			for row in bridegroom_giftlistitems
				row.update_attributes(:customer_id => @customer.id, :date_added => Time.now, :customer_ip => @ip)
			end
			flash[:notice] = "Congratulations. Your giftlist has been saved. You will get a confirmation email soon."
	#		email = OrderMailer.create_confirm(order, customer, partner)
	#		render(:text => "<pre>" + email.enclosed + "</pre>")
			redirect_to :controller => :dashboard, :action => 'index'
			session[:cart] = nil
		else
      render :action => :details
  	end
	end

  # Ajax pull down
  def autocomplete_giftlist_number
    @giftlistnumber = Order.get_orders_and_users_details(params[:customer_number_search])
    if @giftlistnumber.size > 0
    end
    #render :layout => false
    render :partial => 'autocomplete_giftlist_number'
  end

  def auto_complete_for_order_customer_number
    @giftlistnumber = Order.get_orders_and_users_details(params[:customer_number_search])
    render :partial => 'autocomplete_giftlist_number'
  end

	private  #----------------------------------------------------

	def find_cart
		@cart = session[:cart] ||= Cart.new
		#session[:acart] ||= Cart.new
  end

end