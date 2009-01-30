class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include Clearance::App::Controllers::ApplicationController
  before_filter :authenticate
end
