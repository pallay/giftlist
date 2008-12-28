class CreateWeddingDetails < ActiveRecord::Migration

  def self.up
 		create_table :wedding_details do |t|
 			t.integer   :user_id
    	t.datetime  :wedding_date
			t.string    :image_url, :default => "/images/photos/no_image.gif"
			t.string    :venue
			t.timestamps
		end
  end

  def self.down
  	drop_table :wedding_details
  end

end
