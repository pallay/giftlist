class WeddingDetails < ActiveRecord::Base

  belongs_to :users

	validates_presence_of	:wedding_date
	validates_presence_of	:venue,       :message => "Please ensure this is entered to personlise your page."

#	validates_format_of :image_url,
#						:with 		=> %r{\.(gif|jpeg|jpg|png)$}i,
#						:message 	=> "Please ensure this is an URL for a GIF, JPG or PNG image only"

	#file_column :image_url, :root_path => File.join(RAILS_ROOT, "public", "bridegrooms")

end