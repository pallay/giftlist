class CreateOrdersUsers < ActiveRecord::Migration
  
	def self.up
		create_table :orders_users, :id => false do |t|
			t.integer :user_id, :order_id, :null => false
		end
	end

  def self.down
  	drop_table :orders_users
  end

end
