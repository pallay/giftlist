class CreateProducts < ActiveRecord::Migration

	def self.up
		create_table :products do |t|
			t.string :image_url, :category,	:reference, :name
			t.text :description
			t.decimal :unit_cost, :markup_percentage, :markup_amount, :price, :precision => 6, :scale => 2, :default => 0
			t.timestamps
    end
	end

  def self.down
  	drop_table :products
  end

end
