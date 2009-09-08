# This controller handles the activation from email and changing the password 

class AccountsController < ApplicationController

  before_filter :login_required, :except => :show
  before_filter :not_logged_in_required, :only => :show

  # Activate action (from activation code sent to user via email on signup)
  def show
    # Uncomment and change paths to have user logged in after activation
    #self.current_user = User.find_and_activate!(params[:id])
    User.find_and_activate!(params[:id])
    flash[:notice] = "Your account is now activated! You can now log in below."
    redirect_to login_path
  rescue User::ArgumentError
    flash[:error] = 'Activation code not found. Please try creating a new account.'
    redirect_to new_user_path 
  rescue User::ActivationCodeNotFound
    flash[:error] = "Activation code not found. Please try creating a new account."
    redirect_to new_user_path
  rescue User::AlreadyActivated
    flash[:error] = "Oops. You've already activated your account. You can log in below."
    redirect_to login_path
  end

  # User amending the password on their profile action
  def edit
  end

  # User updating the password on their profile action  
  def update
    return unless request.post?
    if User.authenticate(current_user.username, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]        
        if current_user.save
          flash[:notice] = "Password successfully updated."
          redirect_to root_path #profile_url(current_user.username)
        else
          flash[:error] = "An error occured, your password was not changed."
          render :action => 'edit'
        end
      else
        flash[:error] = "The new password does not match the password confirmation."
        @old_password = params[:old_password]
        render :action => 'edit'      
      end
    else
      flash[:error] = "Your old password is incorrect."
      render :action => 'edit'
    end 
  end

end
