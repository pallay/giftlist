module LoginSystem

  def self.included(base)
    base.helper_method :current_user
  end

  protected #---------------------------------

  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    !!current_user
  end

  # Attempt login by: user_id stored in the session.
  #                   http authentication using username and password
  #                   by an expiring token in the cookie
  # False if logins fail. So future calls do not hit the database
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
  end

  # if all logins methods are nil return nil. Otherwise stores the given user_id in session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || :false
  end

  ### Override authorised if need to restrict access to a few actions or need to check
  ### if user has the correct privilages. e.g. only allow non-Pallay's
  ##  def authorised?
  ##    current_user.username != "Pallay"
  ##  end

  # Checks if user is authorised (via current_user ==> login_from_session etc)
  def authorised?(action=nil, resource=nil, *args)
    logged_in?
  end

  ### Use in controllers:
  ## before_filter :login_required                      ==> login required for all actions
  ## before_filter :login_required, :only => [ :edit ]
  ## skip_before_filter :login_required                 ==> skip login for a subclassed controller
  def login_required
    authorised? || access_denied
  end

  # ie. user must not be logged in
  def not_logged_in_required
    !logged_in? || permission_denied
  end

  # ie. true               ... :current_user defined AND rolename == :role
  #     permission_denied  ... :current_user defined AND rolename <> :role 
  #     access_denied      ... :current_user !defined OR rolename <> :role
  def check_role(role)
    unless logged_in? && @current_user.has_role?(role)
      if logged_in?
        permission_denied
      else
        access_denied
      end
    end
  end

  def check_administrator_role
    check_role('administrator')
  end
  
  # Redirects when access-request fails. Default action to login screen.
  # Can override method in controllers if special behaviour needed, e.g. user is not
  # authorised to access the requested action.
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        flash.now[:error] = "Access Denied. You must be logged in to access this feature."
        redirect_to new_session_path
      end
      format.xml do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  def permission_denied
    respond_to do |format|
      format.html do
        store_location
        flash.now[:error] = "You don't have permission to complete that action."
        domain = "http://localhost:3000"
        http_referer = request.env["HTTP_REFERER"]
        request_path = request.env["REQUEST_PATH"]
        full_path = domain + request_path
        if http_referer.nil? || full_path.nil?
          redirect_to root_path
        else
          # The [0..20] represents the 21 characters in http://localhost:3000
          # You have to set that to the number of characters in the domain name
          # i.e. http://www.shaadigiftlist.com 0..29
          if (http_referer[0..20] == domain) && (http_referer != full_path)
            redirect_to http_referer
          else
            redirect_to root_path
          end
        end
      end
      format.xml do
        headers["Status"]           = "Unauthorised"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "You don't have permission to complete this action.", :status => '401 Unauthorised'
      end
    end
  end

  # Store the URI of the current request in session used in #:redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
 end

  # Redirect to the URI in :stored_location :default
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?, :authorized? if base.respond_to? :helper_method
  end

  # Called from current_user
  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # Called from :current_user
  def login_from_basic_auth
    authenticate_with_http_basic do |username, password|
      self.current_user = User.authenticate(username, password)
    end
  end

  # Called from :current_user
  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      user.remember_me
      cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
      self.current_user = user
    end
  end


  # # This is ususally what you want; resetting the session willy-nilly wreaks
  # # havoc with forgery protection, and is only strictly necessary on login.
  # # However, **all session state variables should be unset here**.
  # def logout_keeping_session!
  #   # Kill server-side auth cookie
  #   @current_user.forget_me if @current_user.is_a? User
  #   @current_user = false     # not logged in, and don't do it for me
  #   kill_remember_cookie!     # Kill client-side auth cookie
  #   session[:user_id] = nil   # keeps the session but kill our variable
  #   # explicitly kill any other session variables you set
  # end
  # 
  # # The session should only be reset at the tail end of a form POST --
  # # otherwise the request forgery protection fails. It's only really necessary
  # # when you cross quarantine (logged-out to logged-in).
  # def logout_killing_session!
  #   logout_keeping_session!
  #   reset_session
  # end
  # 
  # #
  # # Remember_me Tokens
  # #
  # # Cookies shouldn't be allowed to persist past their freshness date,
  # # and they should be changed at each login
  # 
  # # Cookies shouldn't be allowed to persist past their freshness date,
  # # and they should be changed at each login
  # 
  # def valid_remember_cookie?
  #   return nil unless @current_user
  #   (@current_user.remember_token?) && 
  #     (cookies[:auth_token] == @current_user.remember_token)
  # end
  # 
  # # Refresh the cookie auth token if it exists, create it otherwise
  # def handle_remember_cookie! new_cookie_flag
  #   return unless @current_user
  #   case
  #   when valid_remember_cookie? then @current_user.refresh_token # keeping same expiry date
  #   when new_cookie_flag        then @current_user.remember_me 
  #   else                             @current_user.forget_me
  #   end
  #   send_remember_cookie!
  # end
  # 
  # def kill_remember_cookie!
  #   cookies.delete :auth_token
  # end
  # 
  # def send_remember_cookie!
  #   cookies[:auth_token] = {
  #     :value   => @current_user.remember_token,
  #     :expires => @current_user.remember_token_expires_at }
  # end


end