class ApplicationController < ActionController::Base
  helper :all
  include Clearance::App::Controllers::ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e| render :text => e.message, :status => :not_found; end
  rescue_from Exception do |e| render :text => e.message, :status => :error; end
#  protect_from_forgery
#  before_filter :authenticate
end
