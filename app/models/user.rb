require 'digest/sha1'

class User < ActiveRecord::Base

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  # prevents user from submitting a crafted form that bypasses activation
  # (anything else a user can change should be added here)
  attr_accessible :login, :email, :password, :password_confirmation

  validates_confirmation_of :password,                                :if => :password_required?
  validates_format_of       :email,    :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
  validates_length_of       :password,              :within => 4..40, :if => :password_required?
  validates_length_of       :login,                 :within => 3..40
  validates_length_of       :email,                 :within => 3..100
	#validates_length_of       :first_name,	          :within => 2..30
	#validates_length_of       :last_name,		          :within => 2..30
  validates_presence_of     :login, :email
  validates_presence_of     :password,                                :if => :password_required?
  validates_presence_of     :password_confirmation,                   :if => :password_required?
	#validates_presence_of     :first_name
	#validates_presence_of     :last_name
 # validates_uniqueness_of   :login, :email,        :case_sensitive => false

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
  
  def activate
    @activated = true # sets flag and state to pending
    self.update_attribute(:activated_at, Time.now.utc)
    self.update_attribute(:activation_code, nil)
  end

  def active?
    activation_code.nil? # If activation code exists, they've not activated yet
  end

  def pending?
    @activated # Returns true if user has just been activated.
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(username, password)
    user = find(:first, :conditions => ['login = ? and activated_at IS NOT NULL', username]) # need to get the salt
    user && user.authenticated?(password) ? user : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
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

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  
  def reset_password
    # Updates :password_reset_code before setting the :reset_password flag
    # to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end 

  # Used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end
  
  def recently_reset_password?
    @reset_password
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
  
  protected #------------------------------------------------

  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
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
  
  private # ----------------------------

  def self.find_customer_all
  	find(:all, :order => "login")
  end
  
  def self.find_order
  	find(:all, :order => "name")
  end
  
end