class CreateGiftMessages < ActiveRecord::Migration

	def self.up
		create_table :gift_messages do |t|
			t.integer :payment_id, :null => false
			t.text :message
      t.timestamps
    end
	end

  def self.down
  	drop_table :gift_messages
  end

end
