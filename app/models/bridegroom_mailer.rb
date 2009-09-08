class BridegroomMailer < ActionMailer::Base

	def registration_confirmation(customer)
		recipients	customer.email
		from	    	"pallay@shaadigiftlist.com"
		subject 	  "Thank you for Registering"
		body		    :customer => customer
	end

end
