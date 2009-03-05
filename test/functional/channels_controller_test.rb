require 'test_helper'

class ChannelsControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @channel = Factory(:channel)
    end    

    signed_in_user_context do
      should "get index" do
        get :index
        assert_response :success
        assert_not_nil assigns(:channels)
      end

      should "get new" do
        get :new
        assert_response :success
      end

      should "create channel" do
        @region = Factory(:region)
        assert_difference('Channel.count') do
          post :create, :channel => { :region_id => @region.id, :keywords => 'sphinx' }
        end
        assert_redirected_to channel_path(assigns(:channel))
      end

      should "show channel" do
        get :show, :id => @channel.id
        assert_response :success
      end

      should "get edit" do
        get :edit, :id => @channel.id
        assert_response :success
      end

      should "update channel" do
        put :update, :id => @channel.id, :channel => { }
        assert_redirected_to channel_path(assigns(:channel))
      end

      should "destroy channel" do
        assert_difference('Channel.count', -1) do
          delete :destroy, :id => @channel.id
        end
        assert_redirected_to channels_path
      end
    end
  end
end