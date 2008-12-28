class EmailregisterController < ApplicationController

	def save_email
		emailperson = Emailregister.new({:email => params[:email]})
		emailperson.save
    end

end
