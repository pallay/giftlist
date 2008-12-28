class CreatePayments < ActiveRecord::Migration

	def self.up
		create_table :payments do |t|
			t.integer   :payment_method_id, :null => false
			t.string    :purchaser_first_name, :purchaser_last_name, :purchaser_email, :purchaser_telephone, :customer_ip
			t.datetime  :date_purchased
      t.timestamps
    end
	end
	
  def self.down
  	drop_table :payments
  end
  
end
