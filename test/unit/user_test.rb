require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  include Clearance::Test::Unit::UserTest

  should_have_many :conversations
  
  context "non web users" do
    should "not be required to include their email" do
      @user = User.create(:number => '12345')
      assert @user.errors.on(:email).blank?
    end
  end
  
  should "test subscriptions text"
end