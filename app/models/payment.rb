class Payment < ActiveRecord::Base

	attr_protected :id, :customer_ip, :status, :updated_at, :created_at

	has_many	:line_items, :foreign_key => 'payment_id'
  has_many	:products, :through => :line_items
	has_one   :payment_method
	has_many	:orders, :through => :line_items
	has_one		:giftmessage

	#validates_format_of	:purchaser_email,	:with => /^ ( [^@\s]+ ) @ ( (?:[-a-z0-9]+\.) + [a-z]{2,} ) $/i

	def thisIP=(ip2)
		@ip = ip2
	end

	def thisIP
		return @ip
	end

end

#
# Part of activemerchant for paypal pro. not implemented yet.
#

#	def process
#		if status == "Closed"
#			raise "Order is closed since process.closed? true"
#			begin
#				process_with_paypal
#			rescue (e)
#				logger.error("Payment #{id} failed with error message #{e}")
#				self.error_message = 'Error while processing order'
#				self.status = 'failed'
#			end
#		save!
#		self.status == 'processed'
#		end
#	end

#	def process_with_paypal
#
#	    total = 1000 # ie. £10.00
#
#		credit_card = ActiveMerchant::Billing::CreditCard.new(
#			:type       => 'visa',
#			:number     => '4242424242424242',
#			:month      => 8,
#			:year       => 2009,
#			:first_name => 'asdl',
#			:last_name  => 'fdg',
#			:verification_value=> '123'
#		)
#
#		#flash[:error] = credit_card.errors and return unless credit_card.valid?
#
#		address = {
#			:name     => "dfg dfg",
#			:address1 => '123 asdasdf',
#			:address2 => '',
#			:city     => 'london',
#			:country  => 'UK',
#			:zip      => 'GU215EP',
#			:phone    => '0208123456789'
#			}
#
#		gateway = ActiveMerchant::Billing::Base.gateway(:paypal).new(
#			:login => $PAYPAL_LOGIN,
#		    :password => $PAYPAL_PASSWORD,
#		    :pem => File.read(File.join(RAILS_ROOT, 'config', 'paypal', 'paypal.pem'))
# 			)
#
#		result = gateway.authorize(
#			total,
#			credit_card,
#			:ip => thisIP,
#			:billing_address => address)
#
#		if result.success?
#			gateway.capture(total, res.authorization)
#			flash[:notice] = "Payl has authorised payment"
#			redirect_to 'index'
#		else
#			#flash[:notice] = "Failure: " + result.message.to_s
#		end
#
#	end

#		Base.gateway_mode = :test
#
#		gateway = PaypalGateway.new(:login		=>	'business_account_login',
#									:password	=>	'business_account_password',
#									:cert_path	=>	File.join(File.dirname(__FILE__), "D:/workspace/idea/shaadigift-bleedingedge/config/paypal") #/../config/paypal")
#									)
#
#		gateway.connection.wiredump_dev = STERR
#
#		# Buyer's Information
#		params = {	:order_id		=>	self.id,
#					:email			=>	'pallay@googlemail.com',
#					:address		=>	{	:address1	=>	'252 Walton Road',
#											:city		=>	'Woking',
#											:country	=>	'EN',
#											:zip		=>	'GU21 5EQ'
#										},
#					:description	=> 'Purchases',
#					:ip				=>	self.customer_ip,
#					:total			=>	'100'
#				}
#
#		response = gateway.purchase(params)
#
#		if response.success?
#			self.status = 'processed'
#		else
#			self.error_message = response.message
#			self.status = 'failed'
#		end
#	end
