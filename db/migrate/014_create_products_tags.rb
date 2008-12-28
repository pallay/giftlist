class CreateProductsTags < ActiveRecord::Migration

	def self.up
		create_table :products_tags, :id => false do |t|
			t.integer :product_id, :tag_id, :null => false
    end
	end

  def self.down
  	drop_table :products_tags
  end
end
