class CreateAddresses < ActiveRecord::Migration

	def self.up
		create_table :addresses do |t|
			t.string :line_one, :line_two, :line_three, :city, :county, :country, :post_code
		  t.timestamps
		end		
	end

  def self.down
  	drop_table :addresses
  end

end
