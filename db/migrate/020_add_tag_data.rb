class AddTagData < ActiveRecord::Migration

  def self.up
  	Tag.create (:tag_name => 'electronics')
  	Tag.create (:tag_name => 'jewellery (male)')
  	Tag.create (:tag_name => 'jewellery (female)')
  end

  def self.down
  	Tag.delete_all
  end

end