class ApplicationController < ActionController::Base

# egs
# belongs_to :bridegroom, :class => 'User'

  include LoginSystem

	before_filter :init_user, :partial_info

	# facebook stuff
	#before_filter :require_facebook_login, :set_user
	#include RFacebook::RailsControllerExtensions

#	def facebook_api_key
#	  return "ae8cd047c535901ff40b92f7e9303fef"
#	end
#
#	def facebook_api_secret
#	  return "e032273a4a5cc28ec41cd08b18d27225"
#	end
#
#	def finish_facebook_login
#	  redirect_to :controller => "giftlists"
#	end
#
#	def set_user
#	  @current_fb_user_id = fbsession.session_user_id
#	end
	# end facebook stuff
	
	private #------------------------------------------

	def initialise_guest
		if session[:customer_number]
			@guestcart = Guestcart.find(session[:guestcart_id])
		else
			@guestcart = Guestcart.create
			session[:guestcart_id] = @guestcart.id
		end
	end

  def init_user
    session[:ip] = request.env["REMOTE_IP"]
  end

  def partial_info
    @recent_users_name = []
    @recent_users_wedding_venue = []
    @recent_users_wedding_image = []
    orders = Order.find(:all, :order => 'created_at ASC')
    orders.each do |o|
      #o.users[0] ? @recent_users_name << "Anon" : @recent_users_name << o.users[0].first_name.capitalize
      #o.users[1] ? @recent_users_name << "Anon" : @recent_users_name << o.users[1].first_name.capitalize
      o.users.each do |u|
        u.first_name.nil? ? @recent_users_name << "Anon" : @recent_users_name << u.first_name.capitalize
        @recent_users_wedding_venue << WeddingDetails.find_by_user_id(u.id).venue.capitalize
        @recent_users_wedding_image << WeddingDetails.find_by_user_id(u.id).image_url
      end
    end
  end

end
