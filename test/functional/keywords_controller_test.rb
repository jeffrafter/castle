require 'test_helper'

class KeywordsControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @keyword = Factory(:keyword)
    end    

    should "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:keywords)
    end

    should "should get new" do
      get :new
      assert_response :success
    end

    should "should create keyword" do
      @channel = Factory(:channel)
      assert_difference('Keyword.count') do
        post :create, :keyword => { :word => 'please', :language => 'ru', :channel_id => @channel }
      end
      assert_redirected_to keyword_path(assigns(:keyword))
    end

    should "should show keyword" do
      get :show, :id => @keyword.id
      assert_response :success
    end

    should "should get edit" do
      get :edit, :id => @keyword.id
      assert_response :success
    end

    should "should update keyword" do
      put :update, :id => @keyword.id, :keyword => { }
      assert_redirected_to keyword_path(assigns(:keyword))
    end

    should "should destroy keyword" do
      assert_difference('Keyword.count', -1) do
        delete :destroy, :id => @keyword.id
      end

      assert_redirected_to keywords_path
    end
  end
end