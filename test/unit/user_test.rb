require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_many :conversations, :deliveries, :ratings, :conversations
  should_belong_to :gateway
  
  context "non web users" do
    should "not be required to include their email" do
      @user = User.create(:number => '12345')
      assert @user.errors.on(:email).blank?
    end
  end
  
  context "time zones" do
    setup do      
      Time.zone.stubs(:now).returns(Time.zone.parse("12:00")+13.hours)        
      @user = Factory(:user_with_number, :timezone_offset => "-7") 
    end
    
    should "find the start of day in the user's time zone" do
      assert_equal 7, @user.start_of_day.hour
    end
  end
end