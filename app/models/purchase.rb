#class Purchase < ActiveRecord::Base
#
#	has_many 	:line_items
#	has_many 	:products, :through => :line_items
#	has_one 	:invoice
#	has_one     :paymentmethod, :foreign_key => :paymentmethod_id
#
#    attr_protected 	:id, :customer_id, :status, :error_message, :updated_at, :created_at
#	attr_accessor	:card_type, :card_number, :card_expiration, :card_expiration_year, :card_verification_value
#
##	validates_size_of	:purchase_items, :minimum => 1
##
##	validates_length_of	:ship_to_first_name,		:in => 2..255
##	validates_length_of :ship_to_last_name, 		:in => 2..255
##	validates_length_of :ship_to_address,			:in => 2..255
##	validates_length_of :ship_to_city,				:in => 2..255
##	validates_length_of :ship_to_postcode,			:in => 2..255
##	validates_length_of :ship_to_country,			:in => 2..255
##	validates_length_of :phone_number,				:in => 11..20
##	validates_length_of :customer_ip,				:in => 7..15
##	validates_length_of	:card_number,				:in => 13..19, :on => :create
##	validates_length_of	:card_verification_number,	:in => 3..4, :on => :create
##
##	validates_format_of	:email,	:with => /^ ( [^@\s]+ ) @ ( (?:[-a-z0-9]+\.) + [a-z]{2,} ) $/i
##
##	validates_inclusion_of	:status, 				:in => %w(open processed closed failed)
##	validates_inclusion_of	:card_type,				:in => ['Visa', 'Mastercard'], :on => :create
##	validates_inclusion_of	:card_expiration_month,	:in => %w(1 2 3 4 5 6 7 8 9 10 11 12), :on => :create
##	validates_inclusion_of	:card_expiration_year,	:in => %w(2006 2007 2008 2009 2010), :on => :create
#
#	def process_with_active_merchant
#		Base.gateway_mode = :test
#
#		gateway = PaypalGateway.new(:login		=>	'business_account_login',
#									:password	=>	'business_account_password',
#									:cert_path	=>	File.join(File.dirname(__FILE__), "../../config/paypal")
#									)
#		gateway.connection.wiredump_dev = STERR
#
#		creditcard = CreditCard.new(:type				=>	card_type,
#									:number				=>	card_number,
#									:verification_value	=> 	card_verification_value,
#									:month				=>	card_expiration_month,
#									:year				=>	card_expiration_year,
#									:first_name			=>	ship_to_first_name,
#									:last_name			=>	ship_to_last_name
#									)
#
#		# Buyer Information
#		params = {	:purchase_id	=>	self.id,
#					:email			=>	email,
#					:address		=>	{	:address1	=>	ship_to_address,
#											:city		=>	ship_to_city,
#											:country	=>	ship_to_country,
#											:zip		=>	ship_to_postcode
#										},
#					:description	=> 'Purchases',
#					:ip				=>	customer_ip
#				}
#
#		response = gateway.purchase(total, creditcard, params)
#
#		if response.success?
#			self.status = 'processed'
#		else
#			self.error_message = response.message
#			self.status = 'failed'
#		end
#
#	end
#
#	private #---------------------------
#
#	def process
#		result = true
#		if closed? raise ("Purchase is closed")
#			begin
#				process_with_active_merchant
#			rescue (e)
#				logger.error("Purchase #{id} failed with error message #{e}")
#				self.error_message = 'Error while processing order'
#				self.status = 'failed'
#			end
#			save!
#			self.status == 'processed'
#		end
#	end
#
#end
