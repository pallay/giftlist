class CreateOrderConditions < ActiveRecord::Migration

  def self.up
		create_table :order_conditions do |t|
			t.string :value
			t.timestamps
  	end
 	end

  def self.down
  	drop_table :order_conditions
  end

end
