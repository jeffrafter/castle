require 'test_helper'

class AreasControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @area = Factory(:area)
    end    

    signed_in_user_context do
      should "should get index" do
        get :index
        assert_response :success
        assert_not_nil assigns(:areas)
      end

      should "should get new" do
        get :new
        assert_response :success
      end

      should "should create area" do
        @region = Factory(:region)
        assert_difference('Area.count') do
          post :create, :area => { :name => 'Area of innovation', 
                                   :country_code => 56, 
                                   :area_code => 35, 
                                   :region_id => @region.id }
        end
        assert_redirected_to area_path(assigns(:area))
      end

      should "should show area" do
        get :show, :id => @area.id
        assert_response :success
      end

      should "should get edit" do
        get :edit, :id => @area.id
        assert_response :success
      end

      should "should update area" do
        put :update, :id => @area.id, :area => { }
        assert_redirected_to area_path(assigns(:area))
      end

      should "should destroy area" do
        assert_difference('Area.count', -1) do
          delete :destroy, :id => @area.id
        end

        assert_redirected_to areas_path
      end
    end
  end
end  