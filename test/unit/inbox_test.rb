require File.dirname(__FILE__) + '/../test_helper'

class InboxTest < Test::Unit::TestCase
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

    should "reject invalid numbers" 
    # TODO Temporarily disabled
    # do
    #   @inbox = Inbox.create(:number => '867-5309', :gateway => @gateway, :text => 'Jenny!')
    #   assert_equal 'is not a valid number', @inbox.errors.on(:number)
    # end
  end  
end
