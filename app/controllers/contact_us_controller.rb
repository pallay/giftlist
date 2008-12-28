class ContactUsController < ApplicationController

	def index
		@page_title = 'Contact Us'
#		Mailer.deliver_contact_us(
#			#:recipients => "contact_us@shaadigiftlist.com",
#			:recipients => "pallay@rockytrack.com",
#			:body => {	:name => params[:name],
#						:email => params[:email],
#						:phone => params[:contact_number],
#						:current_member => params[:current_member],
#						:nature_of_enquiry => params[:nature_of_enquiry],
#						:message => params[:message]
#					},
#			:form => "Contact_Form"
#		)
	end
	
	def save
	  redirect_to root_url
	end

end