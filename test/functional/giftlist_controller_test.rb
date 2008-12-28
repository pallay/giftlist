require File.dirname(__FILE__) + '/../test_helper'
require 'giftlist_controller'

# Re-raise errors caught by the controller.
class GiftlistController; def rescue_action(e) raise e end; end

class GiftlistControllerTest < Test::Unit::TestCase
  def setup
    @controller = GiftlistController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
