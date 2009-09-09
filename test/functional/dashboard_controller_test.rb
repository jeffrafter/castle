require File.dirname(__FILE__) + '/../test_helper'

class DashboardControllerTest < ActionController::TestCase
  context "Dashboard" do
    public_context do
      should "require login to view and return that the response was unauthorized" do       
        get :index
        assert_response :redirect     
      end
    end
    
    signed_in_user_context do
      should "show the dashboard" do
        get :index
        assert_response :success     
      end
    end
  end
end