class OrderMailer < ActionMailer::Base

  def confirm(customer, partner)
    @subject		  = "ShaadiGiftList Gift List Confirmation"
    @body["order", "customer"]	= order, customer
    @recipients		= {customer.email}
	  @from		    	= 'sales@shaadigiftlist.com'
    @sent_on  		= Time.now
    @headers  		= {}
  end

  def shipped(sent_at = Time.now)
    @subject      = "Your Shaadi Gift List has been shipped"
    @body["order", "customer"]	= order, customer, partner
    @recipients   = {customer.email}
    @from         = 'sales@shaadigiftlist.com'
    @sent_on      = Time.now
    @headers      = {}
  end
  
end