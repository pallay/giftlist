class CreateOrders < ActiveRecord::Migration
  
	def self.up
		create_table :orders do |t|
			t.string :customer_number
			t.integer :shipping_address_id, :order_condition_id
		  t.timestamps
		end	
	end

  def self.down
  	drop_table :orders
  end

end
