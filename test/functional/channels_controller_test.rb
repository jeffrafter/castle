require 'test_helper'

class ChannelsControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @channel = Factory(:channel)
    end    

    should "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:channels)
    end

    should "should get new" do
      get :new
      assert_response :success
    end

    should "should create channel" do
      @region = Factory(:region)
      assert_difference('Channel.count') do
        post :create, :channel => { :link => 'http://icecreamflavors.com/feed', 
                                    :region_id => @region.id }
      end
      assert_redirected_to channel_path(assigns(:channel))
    end

    should "should show channel" do
      get :show, :id => @channel.id
      assert_response :success
    end

    should "should get edit" do
      get :edit, :id => @channel.id
      assert_response :success
    end

    should "should update channel" do
      put :update, :id => @channel.id, :channel => { }
      assert_redirected_to channel_path(assigns(:channel))
    end

    should "should destroy channel" do
      assert_difference('Channel.count', -1) do
        delete :destroy, :id => @channel.id
      end
      assert_redirected_to channels_path
    end
  end
end