class CreateTaggings < ActiveRecord::Migration

	def self.up
		create_table :taggings do |t|
			t.integer :tag_id, :taggable_id, :taggable_type
	    t.timestamps
    end
	end
	
  def self.down
  	drop_table :tagging
  end
  
end
