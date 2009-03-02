require 'test_helper'

class ProcessorTest < ActiveSupport::TestCase
  context "processing" do
    setup do
      @text = 'All your bases are belong to us'
      @gateway = Factory(:gateway)
    end
    
    context "message from an unknown user" do
      setup do
        @message = Factory(:inbox, :text => @text, :number => '3108675309', :gateway => @gateway)
      end
      
      should "handle a new message" do 
        should_send_message_to @message.number, /invited/ do
          assert_difference 'User.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end
      
      should "not handle interactions"
      should "not handle commands"
    end

    context "message from an unconfirmed user" do
      setup do
        @user = Factory(:user_with_number, :number_confirmed => false)
      end    

      should "handle a 'yes' message" do
        @message = Factory(:inbox, :text => 'yes', :number => @user.number, :gateway => @gateway)
        should_send_message_to @message.number, /Thanks/ do
          assert_no_difference 'User.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end

      should "handle a 'no' message" do
        @message = Factory(:inbox, :text => 'no', :number => @user.number, :gateway => @gateway)
        should_not_send_message_to @message.number do
          assert_no_difference 'User.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end

      should "not handle interactions"
      should "not handle commands"
    end

    context "message from a deactivated user" do
      setup do
        @user = Factory(:user_with_number, :active => false)
        @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
      end    

      should "should fail" do
        should_not_send_message_to @message.number do
          assert_no_difference 'User.count' do
            assert_raise UserNotActiveError do
              @processor = Message::Processor.new(@message)
              @processor.run
            end  
          end  
        end  
      end
    end

=begin    
    context "message from a confirmed user with a waiting interaction" do
      setup do
        @user = Factory(:user_with_number)
        @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
      end    

      should "should create a new message" do
        @processor = Message::Processor.new(@message)
      end
    end
=end    

    
    context "invite message from a confirmed user" do
      setup do
        @text = 'invite 15558675309'
        @user = Factory(:user_with_number)
        @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
      end    

      should "handle a new message" do 
        should_send_message_to '5558675309', /invited/ do
          assert_difference 'User.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end      
    end

    
  end  
end
