require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @entry = Factory(:entry)
    end    

    should "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:entries)
    end

    should "should get new" do
      get :new
      assert_response :success
    end

    should "should create entry" do
      @channel = Factory(:channel)
      assert_difference('Entry.count') do
        post :create, :entry => { :link => 'http://xkcd.com/595', :channel_id => @channel.id }
      end
      assert_redirected_to entry_path(assigns(:entry))
    end

    should "should show entry" do
      get :show, :id => @entry.id
      assert_response :success
    end

    should "should get edit" do
      get :edit, :id => @entry.id
      assert_response :success
    end

    should "should update entry" do
      put :update, :id => @entry.id, :entry => { }
      assert_redirected_to entry_path(assigns(:entry))
    end

    should "should destroy entry" do
      assert_difference('Entry.count', -1) do
        delete :destroy, :id => @entry.id
      end
      assert_redirected_to entries_path
    end
  end
end