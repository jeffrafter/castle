require 'test_helper'

class RatingHandlerTest < ActiveSupport::TestCase
  context "processing a rating message from a known user" do
    setup do
      Command.create(:locale => 'en', :key => 'rate', :word => 'like')
      @text = 'like'
      @user = Factory(:user_with_number)
      @gateway = Factory(:gateway)
      @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
    end
    
    context "when no deliveries have been made" do
      should "not add a rating" do 
        should_not_send_message_to @message.number do
          assert_no_difference 'Rating.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end
    end

    context "when deliveries have been made" do
      setup do
        @delivery = Factory.build(:delivery, :user_id => @user.id)
        @user.deliveries << @delivery
        @user.save!
      end    

      should "add a rating" do
        should_send_message_to @message.number, /Thanks, your vote/ do
          assert_difference 'Rating.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end
    end    
  end  
end
