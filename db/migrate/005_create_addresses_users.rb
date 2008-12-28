class CreateAddressesUsers < ActiveRecord::Migration

	def self.up
		create_table :addresses_users, :id => false do |t|
			t.integer :address_id, :user_id, :null => false
		end		
	end

  def self.down
  	drop_table :addresses_users
  end

end
