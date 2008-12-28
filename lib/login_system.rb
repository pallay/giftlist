module LoginSystem

  protected #---------------------------------

  # Preloads @current_user with the User model if they're logged in.
  def logged_in?
    current_user != :false
  end

  # Attempt login by: user_id stored in the session.
  #                   http authentication using username and password
  #                   by an expiring token in the cookie
  # False if logins fail. So future calls do not hit the database.
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie || :false)
  end

  # if all logins methods are nil return nil. Otherwise stores the given user_id in session.
  def current_user=(new_user)
    session[:user_id] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
    @current_user = new_user || :false
  end

  ### Override authorised if need to restrict access to a few actions or need to check
  ### if user has the correct privilages. e.g. only allow non-Pallay's
  ##  def authorised?
  ##    current_user.username != "Pallay"
  ##  end

  # Checks if user is authorised (via current_user ==> login_from_session etc)
  def authorised?
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

  # Inclusion hook to make :current_user and :logged_in? available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  # Called from current_user
  def login_from_session
    self.current_user = User.find(session[:user_id]) if session[:user_id]
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

end