require File.dirname(__FILE__) + '/../test_helper'

class InboxTest < ActiveSupport::TestCase
  setup do
    @message = Factory(:inbox)
  end
  
  should_validate_presence_of :number, :gateway, :text
  should_belong_to :gateway  

  context "Given a created gateway and user" do
    setup do
      @gateway = Factory(:gateway)
      @user = Factory(:user_with_number)
    end    
  end  
end
