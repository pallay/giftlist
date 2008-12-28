# This controller handles the login/logout function of the site.  

class SessionsController < ApplicationController

  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:create]

  # login
  def new
    flash.now[:error] = "You are already logged in" if logged_in?
    redirect_to :controller => 'new' unless logged_in? || User.count > 0
    @page_title = "Please Login"
    session[:customer_id] = nil
		session[:cart] = nil
  end

  def create
    password_authentication(params[:login], params[:password])
  end

  # logout
  def destroy		
    @title = "Logout"
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    #session[:customer_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to login_path
  end

  def catcher
    redirect_to root_url
  end

  protected #----------------------------------------------------------------------------

  def password_authentication(username, password)
    self.current_user = User.authenticate(username, password)
    if logged_in?
      successful_login
      session[:customer_id] = current_user.id
    else
      failed_login_text = "Your username or password was entered incorrectly. If it's the first time you've tried to Log In, maybe your account is not activated correctly."
      failed_login_account_disabled_text = "Your account has been disabled"
      disabled = User.find_by_login_and_enabled(username, 0)
      disabled ? failed_login(failed_login_account_disabled_text) : failed_login(failed_login_text)
    end
  end

  private # -----------------------------------------------------------------------------

  def failed_login(message)
    flash.now[:error] = message
    render :action => 'new'
  end

  def successful_login
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = {:value => self.current_user.remember_token, :expires  => self.current_user.remember_token_expires_at }
    end
    flash[:notice] = "Logged in successfully"
    return_to = session[:return_to]
    session[:customer_id] = current_user.id
    if return_to.nil?
      redirect_to :controller => 'dashboard', :action => 'index' #user_path(self.current_user)
    else
      redirect_to return_to
    end
  end

end