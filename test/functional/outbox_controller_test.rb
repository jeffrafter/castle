require File.dirname(__FILE__) + '/../test_helper'

class OutboxControllerTest < ActionController::TestCase
  context "Given a created message" do
    setup do
      @gateway = Factory(:gateway)
      @user = Factory(:user_with_number)
      @message = Factory(:outbox, :number => @user.number, :gateway => @gateway)
    end    

    should "not return messages to an invalid gateway" do
      get :index, :format => 'xml', :api_key => 'monkey'
    end

    should "should return all messages" do
      get :index, :format => 'xml', :api_key => @gateway.api_key
      assert_response :success
      assert_not_nil assigns(:messages)
      assert assigns(:messages).include?(@message)
    end
    
    should "should return all messages since time specified" do
      get :index, :format => 'xml', :api_key => @gateway.api_key, :since => Time.now.utc.iso8601
      assert_response :success
      assert_not_nil assigns(:messages)
      assert_equal [], assigns(:messages)
    end    
  end
end
