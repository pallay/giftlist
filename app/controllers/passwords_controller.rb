class PasswordsController < ApplicationController

  before_filter :not_logged_in_required, :only => [:new, :create]

  def new
    @title = "Password Recovery"
  end

  def create    
    return unless request.post?
    if @user = User.find_email_for_forgotten_password(params[:email])
      @user.forgot_password # adds password_reset_code to db
      @user.save      
      flash[:notice] = "A password reset link has been sent to your email address."
      redirect_to login_path
    else
      flash[:error] = "Could not find a user with that email address. Has it been activated?"
      render :action => 'new'
    end  
  end

  def edit
    @title = "New password"
    if params[:id].nil?
      render :action => 'new'
      return
    end
    flash[:notice] = "Thank you. Please enter a new password"
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
  raise if @user.nil?
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:error] = "That's seems to be an invalid reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)"
    redirect_to new_user_path
  end
  
  def update
    if params[:id].nil?
      render :action => 'new'
      flash[:error] = "Please enter your email address again"
      return
    end
    if params[:password].blank?
      flash[:error] = "Password field cannot be blank."
      render :action => 'edit', :id => params[:id]
      return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
  raise if @user.nil?
    return if @user unless params[:password]
    if (params[:password] == params[:password_confirmation])
    ## Uncomment and comment lines with @user to have the user logged in after reset - not recommended
    # self.current_user = @user #for the next two lines to work
    # current_user.password_confirmation = params[:password_confirmation]
    # current_user.password = params[:password]
    # @user.reset_password
    # flash[:notice] = current_user.save ? "Password reset" : "Password not reset"
      @user.password_confirmation = params[:password_confirmation]
      @user.password = params[:password]
      @user.reset_password        
      flash[:notice] = @user.save ? "Password reset. You can now login" : "Password not reset."
    else
      flash[:error] = "Password mismatch."
      render :action => 'edit', :id => params[:id]
      return
    end  
    redirect_to login_path
  rescue
    logger.error "Invalid Reset Code entered"
    flash[:error] = "That's seems to be an invalid reset code. Please check and retry. (Perhaps your email client inserted a carriage return?)"
    redirect_to forgot_password_path
  end

end
