require 'test_helper'

class RegionsControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @region = Factory(:region)
    end

    should "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:regions)
    end

    should "should get new" do
      get :new
      assert_response :success
    end

    should "should create region" do
      assert_difference('Region.count') do
        post :create, :region => { :name => 'Coolio', :country => 'Monoco', :language => 'du' }
      end
      assert_redirected_to region_path(assigns(:region))
    end

    should "should show region" do
      get :show, :id => @region.id
      assert_response :success
    end

    should "should get edit" do
      get :edit, :id => @region.id
      assert_response :success
    end

    should "should update region" do
      put :update, :id => @region.id, :region => { }
      assert_redirected_to region_path(assigns(:region))
    end

    should "should destroy region" do
      assert_difference('Region.count', -1) do
        delete :destroy, :id => @region.id
      end
      assert_redirected_to regions_path
    end
  end
end