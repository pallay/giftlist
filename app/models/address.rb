class Address < ActiveRecord::Base

	has_and_belongs_to_many :users

#	validates_presence_of	:line_one
#	validates_presence_of	:city
#	validates_presence_of	:post_code

	validates_length_of :line_one, :within => 3..30
	validates_length_of :city, :within => 3..30
	validates_length_of :post_code, :within => 5..9

end
