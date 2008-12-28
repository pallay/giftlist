#class PurchaseItems < ActiveRecord::Base
#
#	belongs_to :purchase
#	belongs_to :product
#
#	def validate
#		errors.add(:quantity, "should be one or more") unless quantity.nil? || quantity > 0
#		errors.add(:price, "should be postive number") unless price.nil? || price > 0.0
#	end
#
#end
