require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @feed = Factory(:feed)
    end    

    signed_in_user_context do
      should "get index" do
        get :index
        assert_response :success
        assert_not_nil assigns(:feeds)
      end

      should "get new" do
        get :new
        assert_response :success
      end

      should "create feed" do
        @channel = Factory(:channel)
        assert_difference('Feed.count') do
          post :create, :feed => { :channel_id => @channel.id, :feed_url => 'http://batdance.com/moves.xml' }
        end
        assert_redirected_to feed_path(assigns(:feed))
      end

      should "show feed" do
        get :show, :id => @feed.id
        assert_response :success
      end

      should "get edit" do
        get :edit, :id => @feed.id
        assert_response :success
      end

      should "update channel" do
        put :update, :id => @feed.id, :feed => { }
        assert_redirected_to feed_path(assigns(:feed))
      end

      should "destroy channel" do
        assert_difference('Feed.count', -1) do
          delete :destroy, :id => @feed.id
        end
        assert_redirected_to feeds_path
      end
    end
  end
end