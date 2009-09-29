require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class AddHandlerTest < ActiveSupport::TestCase
  context "processing an add message from a known user" do
    setup do
      Command.create(:locale => 'en', :key => 'add', :word => 'subscribe')
      @user = Factory(:user_with_number)
      @available_channels = [
        Factory(:channel, :region => @user.gateway.region),
        Factory(:channel, :region => @user.gateway.region),
        Factory(:channel, :region => @user.gateway.region)]
    end
    
    context "when the channel exists and the user is not subscribed" do
      should "subscribe the user to the channel and deliver a message" do 
        @message = Factory(:inbox, :text => @available_channels[0].title, :number => @user.number, :gateway => @user.gateway)
        should_send_message_to @user.number, /You are subscribed/ do
          assert_difference 'Subscription.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end

      should "not subscribe the user to a different channel" do
        @message = Factory(:inbox, :text => @available_channels[0].title, :number => @user.number, :gateway => @user.gateway)
        should_send_message_to @user.number, /You are subscribed/ do
          assert_difference 'Subscription.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
          @user.reload
          assert !@user.subscriptions.map(&:channel).include?(@available_channels[1])
          assert !@user.subscriptions.map(&:channel).include?(@available_channels[2])
        end  
      end
    end
    
    context "when the channel does not exist" do
      should "not subscribe the user to the channel" do
        @message = Factory(:inbox, :text => "likeaboss", :number => @user.number, :gateway => @user.gateway)
        should_send_message_to @user.number, /not subscribed/ do
          assert_no_difference 'Subscription.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end
    end
    
    context "when there are multiple channels" do
      should "subscribe the user to each channel" do
        @message = Factory(:inbox, :text => @available_channels[0..1].map(&:title).join(' '), :number => @user.number, :gateway => @user.gateway)
        should_send_message_to @user.number, /You are subscribed/ do
          @processor = Message::Processor.new(@message)
          @processor.run
          @user.reload
          assert @user.subscriptions.map(&:channel).include?(@available_channels[0])
          assert @user.subscriptions.map(&:channel).include?(@available_channels[1])
          assert !@user.subscriptions.map(&:channel).include?(@available_channels[2])
        end  
      end
    end
    
    context "when the user is already subscribed" do 
      should "not create a second subscription" do
        @user.subscribe(@available_channels[0].id)
        @message = Factory(:inbox, :text => @available_channels[0].title, :number => @user.number, :gateway => @user.gateway)
        should_send_message_to @user.number, /You are subscribed/ do
          assert_no_difference 'Subscription.count' do
            @processor = Message::Processor.new(@message)
            @processor.run
          end  
        end  
      end
    end
  end  
end
