class DashboardController < ApplicationController

	layout 'dashboard'

  before_filter :find_customer
  before_filter :find_cart
  before_filter :login_required, :except => {:controller => :giftlist, :action => :details}

	def self.in_place_loader_for(object, attribute, options = {})
		define_method("get_#{object}_#{attribute}") do
			@item = object.to_s.camelize.constantize.find(params[:id])
			render :text => @item.send(attribute) || "[no value]"
		end
	end

	in_place_edit_for :user, :first_name
	in_place_edit_for :user, :last_name
	in_place_edit_for :user, :date_of_birth
	in_place_edit_for :user, :email
	in_place_edit_for :user, :contact_number
	in_place_edit_for :user, :evening_number
	in_place_edit_for :user, :mobile_number
	in_place_edit_for :user, :username
	in_place_edit_for :user, :password

	in_place_edit_for :address, :line_one
	in_place_edit_for :address, :line_two
	in_place_edit_for :address, :line_three
	in_place_edit_for :address, :city
	in_place_edit_for :address, :county
	in_place_edit_for :address, :country
	in_place_edit_for :address, :post_code

	def index
    get_details
		session[:cart] = nil
		if params[:password]
			@customer.update_attributes(:password => params[:password])
		end
	end

  def show_by_customer_number
    get_details
		session[:cart] ||= nil
		if params[:password]
			@user.update_attributes(:password => params[:password])
		end
    render :action => :index
  end

	def sort
		params[:giftlist_products_list].each_with_index do |id, position|
			sql = ActiveRecord::Base.connection();
			sql.update("UPDATE line_items SET position = #{position + 1}
						      WHERE order_id = #{session[:order_id]}
						      AND product_id = #{id}");
		end
		@giftlist_products = User.find_current_order_products(session[:customer_id], session[:order_id])
		get_details
    render :layout => false, :action => :index
  end

	def show_item
		@product = Product.find(params[:id])
	end

	def edit_details
		get_details
	end

	def add_items
		for item in @cart.items do
			item.quantity.times do
				@new_lineitem = LineItem.new(:order_id => session[:order_id], :product_id => item.product.id, :price => item.price, :customer_id => User.find_by_id(session[:customer_id]), :date_added => Time.now)
				@new_lineitem.save
			end
		end
		if request.xhr?
			flash.now[:notice] = "You Gift List has been updated"
		elsif request.post?
			flash[:notice] = "You Gift List has been updated"
			redirect_to :action => index
		else
			render
		end
	end

	def add_to_cart
	begin
		product = Product.find(params[:id])
	rescue ActiveRecord::RecordNotFound
		logger.error("Attempt to access invalid product #{params[:id]}")
	redirect_to_index("Invalid product")
		else
			@current_item = @cart.add_product(product)
			redirect_to_index unless request.xhr?
		end
	end

	def empty_cart
		session[:cart] = nil
		redirect_to_index unless request.xhr?
	end

	def remove_from_cart
		product = Product.find(params[:id])
		if request.xhr?
			flash.now[:notice] = "Deleted #{product.name}"
		elsif request.post?
			flash[:notice] = "Deleted #{product.name}"
		end
		@current_item = @cart.remove_product(product)
		redirect_to_index unless request.xhr?
	end

	def remove_item
		lineitem_id = LineItem.find(:first, :conditions => {:order_id => session[:order_id], :product_id => params[:id]})
		product = Product.find(params[:id])
		LineItem.delete(lineitem_id)
		if request.xhr?
			flash.now[:notice] = product.name + " has been removed from your Gift List."
		else request.post?
			flash[:notice] = product.name + " has been removed from your Gift List."
		end
		redirect_to_index unless request.xhr?
	end

	def update_details
		if @user.update_attributes(params[:user])
			flash[:notice] = 'Your changes were successfully saved.'
			redirect_to :action => :index
		else
		  render :action => :edit
		end
	end	

	def amend
		@page_title = "Add New Items to your Gift List"
		get_details
		@products = Product.find_products_for_sale.paginate :page => params[:page], :per_page => 12
	end

	private # --------------------------------------------------------------------

  def get_details
    @todays_date = Date.today.strftime('%a the %d of %B %Y').gsub(/(\d+)/) {|s| s.to_i < 31?s.to_i.ordinalize : s}
		#session[:customer_id] = 2 
		@user ||= User.find_by_id(session[:customer_id])
		@user_order = @user.orders.find(:first)
		session[:order_id] = @user_order.id
		@address ||= @user.addresses.find(:first)
		@user_giftlistitems ||= LineItem.find_by_order_id(session[:order_id], :conditions => {:payment_id => nil})
		@giftlist_products ||= User.find_current_order_products(session[:customer_id], session[:order_id])
		wedding_details = WeddingDetails.find_by_user_id(session[:customer_id])
		@wedding_date = wedding_details.wedding_date.strftime('%a the %d of %B %Y').gsub(/(\d+)/) {|s| s.to_i < 31?s.to_i.ordinalize : s}
		@date_diff = wedding_details.wedding_date.to_date - Date.today
		@user_image = wedding_details.image_url
  end

	def find_customer
		unless session[:customer_id]
		  flash.now[:error] = "You need to be logged in first"
		  redirect_to login_url 
		end
		customer_id = session[:customer_id]
	end

	def find_cart
		@cart = session[:cart] ||= Cart.new
	end

	def redirect_to_index(msg = nil)
		flash[:notice] = msg if msg
		redirect_to :action => :index
	end

end