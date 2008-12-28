class CheckoutController < ApplicationController

	layout 'checkout'

	before_filter :find_guestcart

	def index
		@page_title = "Checkout"
		user = User.new
		payment = Payment.new
		giftmessage = GiftMessage.new
		@ip = session[:ip]
	end

	def place_order
		@page_title = "Placing Order"
		user = User.new(params[:user])
		payment = Payment.new(params[:payment])
		inputted_message = params[:giftmessage][:message]
		unless inputted_message.blank?
			giftmessage = GiftMessage.new(params[:giftmessage])
		end
		random_number = rand.to_s
		user.update_attributes(:login => 'gue5t', :password => random_number, :password_confirmation => random_number)
		# :customer_type_id => 3 need to add via permissions,
		payment.update_attributes(:payment_method_id => 1, :customer_ip => @ip, :date_purchased => Time.now)
		if inputted_message
			giftmessage.update_attributes(:payment_id => payment.id)
			giftmessage.save
		end
		(user.save && payment.save) if request.post?
		session[:guestcart].items.each do |guestcart|
			match_cart_item = LineItem.find(:first, :conditions => {:id => guestcart.line_item_id, :order_id => session[:order_id]})
#			if !match_cart_item.nil?
#				sql = ActiveRecord::Base.connection();
#				sql.begin_db_transaction
#				sql.update("UPDATE line_items SET payment_id = #{payment.id}
#					WHERE id = #{guestcartitem.line_item_id}
#					AND order_id = #{session[:order_id]}");
##			sql.update( "UPDATE line_items SET date_purchased = #{Time.now}
##				WHERE id = #{guestcartitem.line_item_id}
##				AND order_id = #{session[:order_id]}");
##			sql.update( "UPDATE customer_ip #{request.env['REMOTE_HOST']}
##				WHERE id = #{guestcartitem.line_item_id}
##				AND order_id = #{session[:order_id]}");
#				sql.commit_db_transaction
				match_cart_item.update_attributes(:payment_id => payment.id, :date_purchased => Time.now, :customer_ip => @ip, :bought => 1)
				#end # end if
		end # end do
		session[:payment_id] = payment.id
		redirect_to :controller => "payment_status", :action => "ok"
		#else
		#	flash[:notice] = "Sorry. There was an error while placing order."
		#	render :action => 'index'
		#end
	end

=begin
  def credit_cart
    amount = 1000 # (1000 pence)
    creditcard = ActiveMerchant::Billing::CreditCard.new(
        :type               => 'visa',
        :number             => 4462796349491700,
        :month              => 06,
        :year               => 2008,
        :first_name         => 'Pallay',
        :last_name          => 'Raunu',
        :verification_value => '123'
      )
      billing_address = { 
          :name       =>  "P Raunu",
          :address1   =>  '123 First St.',
          :address2   =>  '',
          :city       =>  'Leicester',
          :state      =>  'Leicestershire',
          :country    =>  'UK',
          :zip        =>  'LE112SN',
          :phone      =>  '(01725) 456 3256'
      }
    flash[:error] = credit_card.errors and return unless credit_card.valid?
    if creditcard.valid?
      paypal_sandbox_login = 'pallay.raunu_api1.googlemail.com'
      paypal_sandbox_password = 'N2D6J4BJ2THSZEVF'
      gateway = ActiveMerchant::Billing::PaypalGateway.new(:login => paypal_sandbox_login, :password => paypal_sandbox_password)
      response = gateway.authorize(amount, creditcard, :ip => '127.0.0.1', :billing_address => billing_address)
      if response.success?
        gateway.capture(1000, response.authorization)
        flash[:notice] = 'Authorised'
        render :text => "Hazaa!"
      else
        raise StandardError, response.message
      end
    end
  end
=end

 	def show_product
		@product = Product.find(params[:id])
	end

  def thank_you
  	@page_title = 'Thank you!'
  end

	def notify
#	  gateway = ActiveMerchant::Billing::Base.gateway(:paypal).new(
#      :login => 'pallay.raunu_api1.googlemail.com',
#      :password => 'N2D6J4BJ2THSZEVF'
#    )

		notify = Paypal::Notification.new(request.raw_post)
		enrollment = Enrollment.find(notify.item_id)
		if notify.acknowledge
			@payment = Payment.find_by_confirmation(notify.transaction_id) || enrollment.invoice.payments.create(:amount => notify.amount, :payment_method => 'paypal', :confirmation => notify.transaction_id, :description => notify.params['item_name'], :status => notify.status, :test => notify.test?)
	    begin
		    if notify.complete?
				  @payment.status = notify.status
		    else
				  logger.error("Failed to verify Paypal's notification, please investigate")
		    end
	    rescue => e
		    @payment.status = 'Error'
	    raise
		  ensure
			  @payment.save
		  end
	  end
		render :nothing => true

	end

  private #-----------------------------------------------------------

	def find_guestcart
	  if session[:guestcart].nil?
		  flash[:error] = "You have not placed anything in your cart! Please add something."
  	  redirect_to :controller => "guest"
	  end
	end

end

# This is used by Active Merchant for Paypal pro. Not used yet.

=begin
  def place_payment
  	@page_title = "Checkout"
  	@payment = payment.new(params[:payment])
  	@payment.customer_ip = @ip
  	populate_payment
  	if payment.save
  		if @payment.process
  			flash[:notice] = 'Your payment has been submitted and will be processed soon.'
  			session[:payment_id] = @payment_id
  			# Empty the cart
  			@cart.cart_items.destroy_all
  			redirect_to :action => 'thank_you'
  		else
  			flash[:notice] = "Error while placing payment. '#{@payment.error_message}'"
  			render :action => 'index'
  		end
  	else
  		render :action => 'index'
  	end
  end

  private # -----------------------------------------------

  def populate_order
  	for cart_item in @cart.cart_items
  		payment_item = paymentItem.new(:product_id => cart_item.product_id, :price => cart_item.price, :quantity => cart_item.quantity)
  		@payment.payment_items << payment_item
  	end
  end
=end