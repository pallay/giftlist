require 'digest/sha1'

class User < ActiveRecord::Base

  include LoginSystem
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  def self.find_customer_all
    find(:all, :order => "username")
  end

  def self.find_order
    find(:all, :order => "name")
  end

  after_create :send_account_activated_mail

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  # prevents user from submitting a crafted form that bypasses activation
  # (anything else a user can change should be added here)
  attr_accessible :username, :email, :password, :password_confirmation

  validates_length_of       :username,    :within => 3..40, :too_short => "A username must be at least 2 characters long", :too_long => "A username must be less than 40 characters"
  validates_presence_of     :username
  validates_uniqueness_of   :username,    :case_sensitive => false, :message => "That username has already been taken."
  validates_format_of       :username,    :with => /^[a-zA-Z]\w+$/, :message  => 'A username should only comprise letters and/or numbers'
  validates_format_of       :email,    :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i,:message => "Please supply a valid email address e.g. bob@example.com"
  validates_presence_of     :email
  validates_uniqueness_of   :email,    :case_sensitive => false, :message => "That email address is associated with another account"
  validates_length_of       :email,    :within => 6..100
  validates_confirmation_of :password, :if => :password_required?, :message => "Password and password confirmation don't match."
  validates_length_of       :password, :within => 6..40, :if => :password_required?, :too_short => "Password must be more than 6 characters long.", :too_long => "Password must be lass than 40 characters long."
  validates_presence_of     :password, :if => :password_required?
  validates_presence_of     :password_confirmation, :if => :password_required?

  before_save :encrypt_password
  before_create :make_activation_code

	has_and_belongs_to_many :orders
	has_and_belongs_to_many	:addresses
	has_many	        			:line_items, :through => :orders
	has_many		        		:guestcarts
  has_many                :permissions
  has_many                :roles, :through => :permissions
  has_one                 :wedding_details

  validates_date :date_of_birth, :allow_nil => true
  # Do the exception stuff since we are now a follower of skinny controller, fat models
  class ActivationCodeNotFound < StandardError
  end
  
  class AlreadyActivated < StandardError
    attr_reader :user, :message;
    def initialize(user, message=nil)
      @message, @user = message, user
    end
  end

  # Finds user from corresponding activation code, activates their account and returns the user.
  # Raises:
  #  * User::ActivationCodeNotFound if there is no user with the corresponding activation code
  #  * User::AlreadyActivated if the user with the corresponding activation code has already activated their account
  def self.find_and_activate!(activation_code)
  raise ArgumentError if activation_code.nil?
    user = find_by_activation_code(activation_code)
  raise ActivationCodeNotFound if !user
  raise AlreadyActivated.new(user) if user.active?
    user.activate
    user
  end

  def self.find_current_order_products(customer_id, order_id)
    self.find_by_sql(["
  	  SELECT	    `orders`.`id`,
			            `orders`.`order_condition_id`,
					  	    `line_items`.`customer_id`,
					  	    `line_items`.`position`,
					  	    `line_items`.`payment_id`,
					  	    `line_items`.`id` as line_item_id,
					  	    `products`.`id`,
					  	    `products`.`image_url`,
					  	    `products`.`category`,
					  	    `products`.`name`,
					  	    `products`.`description`,
					  	    `products`.`unit_cost`,
					  	    `products`.`price`,
					  	    `products`.`created_at`,
					  	    `products`.`updated_at`,
					  	    Count(line_items.product_id) as quantity
		  FROM    		`line_items`
		  Inner Join	`orders` ON `line_items`.`order_id` = `orders`.`id`
		  Inner Join	`products` ON `line_items`.`product_id` = `products`.`id`
		  Inner Join	`orders_users` ON `orders`.`id` = `orders_users`.`order_id`
		  Inner Join	`users` ON `orders_users`.`user_id` = `users`.`id`
		  WHERE		    `orders`.`order_condition_id` > 1
		  AND			    `users`.`id` = ? AND `orders`.`id` = ?
		  GROUP BY	  `line_items`.`product_id`
		  ORDER BY	  `line_items`.`position` ASC", customer_id, order_id
		])
  end

  after_save :stop_subsequently_password_required_requests

  def self.authenticate(uname, password)
    user = find :first, :conditions => {:username => uname}
    user && user.authenticated?(password) ? user : nil
  end

  def username=(uname)
    self.write_attribute(:username, uname.downcase)
  end

  def validate_password_reset
    self.password_reset_code_confirmation? ? validate_password_reset_code : validate_current_password
  end

  def validate_password_reset_code
    errors.add :password_reset_code, 'The password reset code is incorrect. Did you follow the email link?' unless (self.password_reset_code_confirmation == self.password_reset_code)
  end
    
  def validate_current_password
    # !! console users can use user.save(false) to skip the check
    errors.add :current_password, 'Your current password is incorrect.' if (self.current_password && !authenticated?(self.current_password))
  end

  # user has forgotten their password so make a reset_code in db
  def forgot_password
    self.make_password_reset_code
    UserMailer.deliver_forgot_password(self)
  end
  
  def reset_password
    self.update_attribute(:password_reset_code, nil)
    UserMailer.deliver_reset_password(self)
  end 

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
 
  def self.find_email_for_forgotten_password(email)
    find :first, :conditions => ['email = ? and activation_code IS NULL', email]
  end
   
  def has_role?(role_name)
    self.roles.find_by_role_name(role_name) ? true : false
  end
  
  def formatted_name
    #{first_name} + #{last_name}
  end

  def send_account_activated_mail
    UserMailer.deliver_account_activated(self)
  end

  protected #------------------------------------------------

  def make_password_reset_code
    self.password_reset_code = self.class.make_token
  end

  # No encrypted password in db OR a new password has been supplied
  def password_required?
    crypted_password.blank? || !password.blank?
  end

  # after_save: make sure subsequent saves don't trigger password_required?
  def stop_subsequently_password_required_requests
    self.password = nil if password_required?
  end

  def active?
    activation_code.nil? # If activation code exists, they've not activated yet
  end

  def pending?
    @activated # Returns true if user has just been activated.
  end

  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.username}--") if new_record?
    self.crypted_password = encrypt(password)
  end
    
  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
  end

  def make_password_reset_code
     self.password_reset_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
  end

end

#
#   has_many :user_logs
# 
#   named_scope :activity_within, lambda { |time|
#     {:conditions => ['user_logs.created_at > ?', Time.now - time],
#      :select => 'users.id, users.username',
#      :joins => 'INNER JOIN user_logs ON user_logs.user_id = users.id',
#      :group => 'users.id'}
#     }
#   attr_accessor :current_password, :password_reset_code_confirmation  
#
# end