require File.dirname(__FILE__) + '/../test_helper'
require 'guestcart_controller'

# Re-raise errors caught by the controller.
class GuestcartController; def rescue_action(e) raise e end; end

class GuestcartControllerTest < Test::Unit::TestCase
  def setup
    @controller = GuestcartController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
