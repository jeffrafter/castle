require File.dirname(__FILE__) + '/../test_helper'
require 'responses_controller'

# Re-raise errors caught by the controller.
class ResponsesController; def rescue_action(e) raise e end; end

class ResponsesControllerTest < Test::Unit::TestCase
  fixtures :responses

  def setup
    @controller = ResponsesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:responses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_responses
    old_count = Responses.count
    post :create, :responses => { }
    assert_equal old_count+1, Responses.count
    
    assert_redirected_to responses_path(assigns(:responses))
  end

  def test_should_show_responses
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_responses
    put :update, :id => 1, :responses => { }
    assert_redirected_to responses_path(assigns(:responses))
  end
  
  def test_should_destroy_responses
    old_count = Responses.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Responses.count
    
    assert_redirected_to responses_path
  end
end
