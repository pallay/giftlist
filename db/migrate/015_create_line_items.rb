class CreateLineItems < ActiveRecord::Migration

	def self.up
		create_table :line_items do |t|
			t.integer :product_id, :order_id,		:null => false
			t.integer :payment_id, :customer_id, :position, :added_by				
			t.boolean :bought, :default => 0
			t.string :visible, :customer_ip
			t.decimal :price, :precision => 6, :scale => 2, :default => 0
			t.datetime :date_purchased, :date_added
      t.timestamps
    end	
	end

  def self.down
  	drop_tables :LineItems
  end
  
end
