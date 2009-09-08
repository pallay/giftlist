# This controller handles the creating, updating and disabling (viz deleting) of a user

class UsersController < ApplicationController

  before_filter :not_logged_in_required, :only => [:new, :create,] 
  before_filter :login_required, :only => [:edit, :update]
  before_filter :check_administrator_role, :only => [:destroy, :enable]

  def index
    @page_title = 'List of all Brides and Grooms'
    @all_users = User.find(:all, :order => "created_at")
    @brides = Role.find_by_role_name('bride').users
    @grooms = Role.find_by_role_name('groom').users
    @current_user = current_user
  end

  def show
    @current_user = current_user # i.e. can only view own profile  
    @user = User.find(params[:id])  
  end

  def show_by_login
    @user = User.find_by_username(params[:username])
    render :action => 'show'
  end
  
  def new
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    ## below protects against session fixation attacks, can wreak havoc with request forgery protection
    ## reset_session # (uncomment at your own risk!!!)
    @user = User.new(params[:user])
    @user.save!
    ## Uncomment: to have user automatically log in after creating account
    ## self.current_user = @user
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account and then log in"
    redirect_to login_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account"
    render :action => 'new'
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user)
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to :action => 'show', :id => current_user
    else
      render :action => 'edit'
    end
  end

  def destroy # Disables user not delete them from the database
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'index'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
    redirect_to :action => 'index'
  end

end
