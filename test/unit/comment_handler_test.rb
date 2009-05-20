require 'test_helper'

class RatingHandlerTest < ActiveSupport::TestCase
  context "processing a comment message from a known user" do
    setup do
      Command.create(:locale => 'en', :key => 'comment', :word => 'comment')
      @text = 'comment hey'
      @user = Factory(:user_with_number)
      @gateway = Factory(:gateway)
      @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
    end
    
    should "add a comment" do
      should_send_message_to @message.number, /Thanks, your comment/ do
        @processor = Message::Processor.new(@message)
        @processor.run
      end  
    end
  end  
end
