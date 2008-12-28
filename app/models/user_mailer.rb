class UserMailer < ActionMailer::Base
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'You need to activate your account'
    @body[:activate_url]  = "#{@url}/activate/#{user.activation_code}"
    @body[:account_creation_faq_url] = "http://www.rockytrack.co.uk/support/account_creation_faq"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:login_url]  = "#{@url}/login/"
    @body[:account_creation_faq_url] = "http://www.rockytrack.co.uk/support/account_creation_faq"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += 'You have requested a password reset'
    @body[:reset_password_url]  = "#{@url}/reset_password/#{user.password_reset_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject += 'Your password has been reset.'
    @body[:login_url] = "#{@url}/login"
    
  end
  
  protected #---------------------------------------
    
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "admin@rockytrack.co.uk"
    @subject     = "rockytrack.co.uk - "
    @sent_on     = Time.now
    @body[:user] = user
    @url         = "http://localhost:3000"
  end

end