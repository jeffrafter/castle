require 'test_helper'

class GatewaysControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @gateway = Factory(:gateway)
    end    

    signed_in_user_context do
      should "should get index" do
        get :index
        assert_response :success
        assert_not_nil assigns(:gateways)
      end

      should "should get new" do
        get :new
        assert_response :success
      end

      should "should create gateway" do
        @region = Factory(:region)
        assert_difference('Gateway.count') do
          post :create, :gateway => { :number => '+123456789', :region_id => @region.id }
        end
        assert_redirected_to gateway_path(assigns(:gateway))
      end

      should "should show gateway" do
        get :show, :id => @gateway.id
        assert_response :success
      end

      should "should get edit" do
        get :edit, :id => @gateway.id
        assert_response :success
      end

      should "should update gateway" do
        put :update, :id => @gateway.id, :gateway => { }
        assert_redirected_to gateway_path(assigns(:gateway))
      end

      should "should destroy gateway" do
        assert_difference('Gateway.count', -1) do
          delete :destroy, :id => @gateway.id
        end

        assert_redirected_to gateways_path
      end
    end
  end
end  