require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  context "Given a created record" do
    setup do
      @entry = Factory(:entry)
    end    

    signed_in_user_context do
      should "get index" do
        get :index
        assert_response :success
        assert_not_nil assigns(:entries)
      end

      should "get new" do
        get :new
        assert_response :success
      end

      should "create entry" do
        @feed = Factory(:feed)
        assert_difference('Entry.count') do
          post :create, :entry => { :url => 'http://xkcd.com/595', :feed_id => @feed.id }
        end
        assert_redirected_to entry_path(assigns(:entry))
      end

      should "show entry" do
        get :show, :id => @entry.id
        assert_response :redirect
        assert_redirected_to entries_path
      end

      should "get edit" do
        get :edit, :id => @entry.id
        assert_response :success
      end

      should "update entry" do
        put :update, :id => @entry.id, :entry => { }
        assert_redirected_to entry_path(assigns(:entry))
      end

      should "destroy entry" do
        assert_difference('Entry.count', -1) do
          delete :destroy, :id => @entry.id
        end
        assert_redirected_to entries_path
      end
    end
  end
end  