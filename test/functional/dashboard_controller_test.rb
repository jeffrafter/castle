require File.dirname(__FILE__) + '/../test_helper'

class DashboardControllerTest < ActionController::TestCase
  context "Dashboard" do
    should "require login to view" do
      get :index
      assert_response(401)

    end
  end
end