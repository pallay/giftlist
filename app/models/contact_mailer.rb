class ContactMailer < ActionMailer::Base
  
  def contact_form(contact)
    @recipients             = ["therocks.vault@googlemail.com", "talk2us@rockytrack.co.uk"]
    @from                   = contact.email_address
    @subject                = "From the rockytrack.co.uk Contact Form"
    @body[:name]            = contact.name
    @body[:phone_number]    = contact.phone_number
    @body[:email_address]   = contact.email_address
    @body[:message]         = contact.message
  end 

end