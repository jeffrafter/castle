require File.dirname(__FILE__) + '/../test_helper'

class InboxControllerTest < ActionController::TestCase
  context "inbox controller" do
    setup do
      @gateway = Factory(:gateway)
    end    

    context "message from a user" do
      should "create a new message" do
        assert_difference 'Inbox.count' do
          post :create, :api_key => @gateway.api_key,
           :inbox => { :text => 'From the beyond', :number => '3108675309' }
        end
        assert_response :success
      end
      
      should "not create a message from an invalid gateway" do
        assert_no_difference 'Inbox.count' do
          post :create, :api_key => 'monkey',
           :inbox => { :text => 'From the beyond', :number => '3108675309' }
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
          post :create, :api_key => @gateway.api_key,
           :inbox => { :text => 'From the beyond', :number => @user.number }
        end
        assert_response :error
      end
    end
  end
end