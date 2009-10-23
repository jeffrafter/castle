require File.dirname(__FILE__) + '/../test_helper'

class TextmagicControllerTest < ActionController::IntegrationTest  
  context "textmagic controller" do
    setup do
      @gateway = Factory(:gateway)
    end    

    context "message from a user" do
      should "create a new message" do
        assert_difference 'Inbox.count' do
          post "/#{@gateway.api_key}/textmagic", :from => 'From the beyond', :text => '3108675309', :timestamp => '1256335010'
        end
        assert_response :success
      end
      
      should "not create a message from an invalid gateway" do
        assert_no_difference 'Inbox.count' do
          post "/monkey/textmagic", :from => 'From the beyond', :text => '3108675309', :timestamp => '1256335010'
        end
        assert_response :error
      end
    end

    context "message from a deactivated user" do
      setup do
        @user = Factory(:user_with_number, :active => false)
      end    

      should "create a new message, but should respond with an error" do
        assert_difference 'Inbox.count' do
          post "/#{@gateway.api_key}/textmagic", :from => @user.number, :text => '3108675309', :timestamp => '1256335010'
        end
        assert_response :error
      end
    end
    
    context "status update" do    
      setup do
        @outbox = Factory(:outbox, :identifier => 23)
      end
    
      should "update the status of known messages" do
        post "/#{@gateway.api_key}/textmagic/callback", :status => 'Wonderful', :message_id => @outbox.identifier, :charge => '10', :timestamp => '1256335010'
        assert_response :success, @response.body
        @outbox.reload
        assert_equal 'Wonderful', @outbox.status        
      end
      
      should "not update the status of unknown messages" do
        post "/monkey/textmagic/callback", :status => 'Wonderful', :message_id => @outbox.identifier, :charge => '10', :timestamp => '1256335010'
        assert_response :error
      end
    end    
  end
end