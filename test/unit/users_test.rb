require File.dirname(__FILE__) + '/../test_helper'

class UsersTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

  def test_should_create_users
    assert_difference Users, :count do
      users = create_users
      assert !users.new_record?, "#{users.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference Users, :count do
      u = create_users(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference Users, :count do
      u = create_users(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference Users, :count do
      u = create_users(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference Users, :count do
      u = create_users(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), Users.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), Users.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_users
    assert_equal users(:quentin), Users.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  protected
    def create_users(options = {})
      Users.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
