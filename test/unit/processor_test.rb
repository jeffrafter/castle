require 'test_helper'

class ProcessorTest < ActiveSupport::TestCase
  context "processing" do
    setup do
      @text = 'All your bases are belong to us'
      @gateway = Factory(:gateway)
    end
    
    context "message from an unknown user" do
      setup do
        @message = Factory(:inbox, :text => @text, :number => '+19519020972', :gateway => @gateway)
      end
      
      should "handle a new message" do 
        should_send_message_to @message.number, /Welcome/ do
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
        @user = Factory(:user_with_number, :number => '+19519020972', :number_confirmed => false)
      end    

      should "handle a 'yes' message" do
        Command.create(:locale => 'en', :key => 'yes', :word => 'yes')
        Command.create(:locale => 'en', :key => 'no', :word => 'no')
        @message = Factory(:inbox, :text => 'yes', :number => @user.number, :gateway => @gateway)
        should_send_message_to @message.number, /For a list of commands/ do
          assert_no_difference 'User.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end

      should "handle a 'no' message" do
        Command.create(:locale => 'en', :key => 'yes', :word => 'yes')
        Command.create(:locale => 'en', :key => 'no', :word => 'no')
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

      should "fail" do
        should_not_send_message_to @message.number do
          assert_no_difference 'User.count' do
            should_raise UserNotActiveError do
              @processor = Message::Processor.new(@message)
              @processor.run
            end  
          end  
        end  
      end
    end
    
    context "invite message from a confirmed user" do
      setup do
        @text = 'invite +14448675309'
        @user = Factory(:user_with_number)
        @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
      end    

      should "handle a new message" do 
        Command.create(:locale => 'en', :key => 'invite', :word => 'invite')
        assert_difference 'User.count' do
          @processor = Message::Processor.new(@message)
          @processor.run
        end  
      end      
    end

    context "add message from a confirmed user" do
      setup do
        @channel = Factory(:channel)
        @user = Factory(:user_with_number)
        @text = "add #{@channel.title}"
        @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
      end    

      should "handle a new message" do 
        Command.create(:locale => 'en', :key => 'add', :word => 'add')
        @processor = Message::Processor.new(@message)
        @processor.run
      end      
    end



=begin    
    context "message from a confirmed user with a waiting interaction" do
      setup do
        @user = Factory(:user_with_number)
        @message = Factory(:inbox, :text => @text, :number => @user.number, :gateway => @gateway)
      end    

      should "create a new message" do
        @processor = Message::Processor.new(@message)
      end
    end
=end    
    
  end  
end
