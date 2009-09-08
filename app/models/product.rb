class Product < ActiveRecord::Base

	acts_as_taggable

	has_many :orders, :through => :line_items
	has_many :guestcart_items
	has_many :guestcarts, :through => :guestcart_items
	belongs_to :line_items, :foreign_key => 'product_id'

	validates_presence_of 		:image_url, :category, :product_reference, :name, :description,
								            :unit_cost, :markup_percentage, :markup_amount, :price
	validates_numericality_of	:unit_cost, :markup_percentage, :markup_amount, :price
	validates_uniqueness_of 	:product_reference
	validates_format_of		  	:image_url,
								            :with    => %r{\.(gif|jpg|jpeg|png)$}i,
								            :message => "must be a URL for a GIF, JPG, or PNG image"

	def self.find_products_for_sale
		find(:all, :order => "name")
	end

	protected #--------------------------------------------------------------------------

	def validate
		errors.add(:unit_cost, "should be at least £0.01") if unit_cost.nil? || unit_cost < 0.01
		errors.add(:price, "should be at least £0.01") if price.nil? || price < 0.01
	end

end
